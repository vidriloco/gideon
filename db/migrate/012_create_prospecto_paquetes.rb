class CreateProspectoPaquetes < ActiveRecord::Migration
  def self.up
    create_table :prospecto_paquetes do |t|
    	t.column :servicio, 			:string
    	t.column :paquete, 				:string
    end
    
    ProspectoPaquete.create(:servicio => "Internet", :paquete => "64 kbps")
    ProspectoPaquete.create(:servicio =>"Internet", :paquete =>"256 kbps")
    ProspectoPaquete.create(:servicio =>"Internet", :paquete =>"512 kbps")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"ALO 100")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"ALO 150")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"ALO Doble")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"Identificador de Llamadas")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"Llamada en espera")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"Conferencia Tripartíta")
    ProspectoPaquete.create(:servicio =>"Telefonía", :paquete =>"Control de Llamadas")
    ProspectoPaquete.create(:servicio =>"Televisión", :paquete =>"Mini Básico")
    ProspectoPaquete.create(:servicio =>"Televisión", :paquete =>"Básico")
    ProspectoPaquete.create(:servicio =>"Televisión", :paquete =>"Digital")
    ProspectoPaquete.create(:servicio => "Televisión", :paquete =>"Digital Premium")
  end

  def self.down
    drop_table :prospecto_paquetes
  end
end
