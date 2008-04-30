class CreateClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
    	t.column :número_de_contrato,		    :integer, :unique => true
    	t.column :nombre,											:string
    	t.column :apellido_paterno,					:string
    	t.column :apellido_materno,					:string
    	t.column :calle,												:string
    	t.column :número_interior,						:string	
    	t.column :número_exterior,        		:string
		  t.column :colonia, 	  								:string
		  t.column :código_postal,   						:integer
		  t.column :teléfono_alo,								:integer
    	t.column :teléfono_telmex,						:integer
		  t.column :primera_calle_de_referencia,	:string
		  t.column :segunda_calle_de_referencia,	:string
	  	t.column :municipio,	  							:string
		  t.column :estado, 	     								:string
    end
  end

  def self.down
    drop_table :clientes
  end
end
