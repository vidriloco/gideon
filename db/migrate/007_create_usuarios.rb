class CreateUsuarios < ActiveRecord::Migration
  def self.up
     
    create_table :usuarios do |t|
			t.column :nombre_de_usuario, 	  :string
			t.column :password_salt,		 		:string
			t.column :password_hash,				:string
    end

  end

  def self.down
    drop_table :usuarios
  end
end
