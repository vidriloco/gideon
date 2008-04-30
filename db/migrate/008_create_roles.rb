class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :nombre, :string
    end

    create_table :usuario_roles do |t|
      t.column :usuario_id, :integer
      t.column :rol_id, :integer
      t.column :created_at, :datetime
    end
    Rol.create(:nombre => "Administrador")
    Rol.create(:nombre => "Plaza")
    Rol.create(:nombre => "Agente") 
    Rol.create(:nombre => "NOC")
    Rol.create(:nombre => "Supervisor")
    
    @u1 = Usuario.create(:nombre_de_usuario => "Admin", :contraseña => "123456", :rol => "Administrador")
    @u2 = Usuario.create(:nombre_de_usuario => "Celaya", :contraseña => "celaya", :rol => "Plaza")
    @u3 = Usuario.create(:nombre_de_usuario => "San Luis", :contraseña => "sanluis", :rol => "Plaza")
    @u1.agrega_rol("Administrador")
    @u2.agrega_rol("Plaza")
    @u3.agrega_rol("Plaza")
  end

  def self.down
    drop_table :roles
    drop_table :usuario_roles
  end
end
