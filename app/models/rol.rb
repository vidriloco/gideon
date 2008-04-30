class Rol < ActiveRecord::Base
	validates_presence_of :nombre, :message => "no debe ser vacío"
	def self.nombres
		roles_conjunto = Rol.find(:all)
		@roles = Array.new
		for rol in roles_conjunto
			@roles << rol.nombre
		end
		@roles
	end
	
	
end
