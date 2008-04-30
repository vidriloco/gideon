class CreateEstados < ActiveRecord::Migration
  def self.up
    create_table :estados do |t|
		t.column :estado,   		:string
    end
	 
    Estado.create(:estado => "Estado de México")
	 Estado.create(:estado => "Tabasco")
	 Estado.create(:estado => "Tamaulipas")
	 Estado.create(:estado => "Guanajuato")
	 Estado.create(:estado => "Querétaro")
    Estado.create(:estado => "San Luis Potosí")
  end

  def self.down
    drop_table :estados
  end
end
