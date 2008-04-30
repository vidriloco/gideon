class CreateProspectoCablepaquetes < ActiveRecord::Migration
  def self.up
    create_table :prospecto_cablepaquetes do |t|
    	t.column :cablepaquete, 				:string
    end
    
    ProspectoCablepaquete.create(:cablepaquete =>"Lócal")
    ProspectoCablepaquete.create(:cablepaquete =>"Móvil")
    ProspectoCablepaquete.create(:cablepaquete =>"Larga Distancia Nacional (LDN)")
  end

  def self.down
    drop_table :prospecto_cablepaquetes
  end
end
