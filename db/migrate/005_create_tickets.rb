class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
	    t.column :llamada_id,				 :integer
	    t.column :enviar_a,          :string
	    t.column :dueno,             :string
	    t.column :estado,            :string
	    t.column :prioridad,         :string
	    t.column :adjunto,           :binary
	    t.column :timestamp,         :date
	    #true si el ticket está abierto
	    t.column :abierto,           :boolean
	    #true si está marcado para darle seguimiento
	    t.column :marcado, 				  :boolean   
    end
  end

  def self.down
    drop_table :tickets
  end
end
