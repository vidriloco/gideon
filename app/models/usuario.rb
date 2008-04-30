require 'digest/sha2'
class Usuario < ActiveRecord::Base
  has_many :tickets
  has_many :usuario_roles
  has_many :roles, :through => :usuario_roles
  validates_presence_of :nombre_de_usuario, :message => "no debe ser vacío"
  validates_uniqueness_of :nombre_de_usuario, :message => "ya registrado"
  validates_confirmation_of :contraseña, :message => "debe coincidir en ambos campos"
  validates_length_of :contraseña, :minimum => 6, :message => "debe ser mínimo de 6 caracteres de longitud"
  validates_presence_of :rol, :message => "no debe ser vacío"
  attr_accessor :contraseña_confirmation
  attr_accessor :rol
	
	def encrypted_password(contraseña, salt) 
    string_to_hash = contraseña + "wibble" + salt # 'wibble' makes it harder to guess 
    Digest::SHA256.hexdigest(string_to_hash) 
  end
  
	def authenticate(clave)
    expected_password = self.encrypted_password(clave, self.password_salt) 
    if self.password_hash != expected_password 
      return false
    end 
    true
  end
  
  def contraseña 
    @contraseña
  end

  def contraseña=(pwd) 
    @contraseña = pwd 
    return if pwd.blank? 
    create_new_salt 
    self.password_hash = self.encrypted_password(self.contraseña, self.password_salt) 
  end
  
  def self.nombre_de_usuarios
  	 todos_los_usuarios = self.find(:all)
  	 @usuarios = Array.new
  	  for usuario in todos_los_usuarios
  	  	 @usuarios << usuario.nombre_de_usuario
  	  end
  	 @usuarios
  end
  
  def self.plazas
  	todas_las_plazas = self.find(:all)
  	@plazas = Array.new
  	for plaza in todas_las_plazas
  		if plaza.tiene_rol? PLAZA
  			@plazas << plaza.nombre_de_usuario
  		end
  	end
  	@plazas
  end
  
  def tiene_rol?(rol)
    self.roles.count(:conditions => ['nombre = ?', rol]) > 0
  end

  def agrega_rol(rol)
    return if self.tiene_rol?(rol)
    self.roles << Rol.find_by_nombre(rol)
  end
  
  def rol_tipo
  	self.roles[0].nombre
  end

  private
  
  def create_new_salt 
    self.password_salt = self.object_id.to_s + rand.to_s 
  end 
  
end
