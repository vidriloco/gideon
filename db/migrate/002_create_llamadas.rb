class CreateLlamadas < ActiveRecord::Migration
  def self.up
   	create_table :llamadas do |t|
				t.column :type, 							:string
			# Atributos comunes a todas las llamadas
				t.column :cliente_id,					    :integer
  	   	t.column :tipo_de_llamada,			  :string
				t.column :contacto,					      :integer
				t.column :estado, 						      :string
    		t.column :fecha_y_hora,				    :datetime
    		t.column :agente,						      :string
      	t.column :producto, 					    :string
	    	t.column :concepto_de_la_llamada,			:string
	    	t.column :resultado_de_la_llamada,     :string
	    	t.column :orden, 									:string
			# Atributos comunes a tipo=Falla
	    	t.column :no_reporte,					    :string
	    	t.column :comentarios,				    :text
	    	t.column :fecha_de_solución,		  :datetime
			# Atributos comunes a tipo=Prospecto
	    	t.column :paquete,			 			    :string
	    	t.column :cablepaquetes,				  :string
	    	t.column :línea,							      :string
	    	t.column :soluciones, 				    :text
	    	t.column :fecha_de_instalación,	:date
	    	t.column :fecha_de_cobro,			  :date
	    	t.column :digital,						    :string

   	end
		
		add_index :llamadas, :cliente_id
  end

  def self.down
    drop_table :llamadas
  end
end
