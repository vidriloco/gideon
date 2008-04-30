class CreateProcesos < ActiveRecord::Migration
  def self.up
    create_table :procesos do |t|
    	t.column 	:tipo_de_llamada, 			:string
    	t.column	:proceso, 							:string
    end
    
	  Proceso.create(:tipo_de_llamada => "falla", :proceso => "Pendiente de Corte")
	  Proceso.create(:tipo_de_llamada => "falla", :proceso => "Cancelado por Imposibilidad Técnica")
	  Proceso.create(:tipo_de_llamada => "falla", :proceso => "Pendiente de Reconectar")
	  Proceso.create(:tipo_de_llamada => "omni", :proceso => "Pendiente de Instalar")
	  Proceso.create(:tipo_de_llamada => "falla", :proceso => "Cancelado Pendiente de Retiro")
	  Proceso.create(:tipo_de_llamada => "prospecto", :proceso => "Contrato")
  end

  def self.down
    drop_table :procesos
  end
end
