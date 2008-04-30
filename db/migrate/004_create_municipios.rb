class CreateMunicipios < ActiveRecord::Migration
  def self.up
    create_table :municipios do |t|
		t.column :estado_id,			:integer, :null => false
		t.column :localidad, 			:string
    end
	 
	 Municipio.create(:estado_id => 1, :localidad => "Ecatepec")
	 Municipio.create(:estado_id => 1, :localidad => "Tultepec")
    Municipio.create(:estado_id => 1, :localidad => "Naucalpan")
	 Municipio.create(:estado_id => 1, :localidad => "Coacalco")
    Municipio.create(:estado_id => 1, :localidad => "Amecameca")
    Municipio.create(:estado_id => 1, :localidad => "Nezahualcoyotl")
    Municipio.create(:estado_id => 2, :localidad => "Villahermosa")
    Municipio.create(:estado_id => 2, :localidad => "Cárdenas")
	 Municipio.create(:estado_id => 2, :localidad => "Comalcalco")
	 Municipio.create(:estado_id => 3, :localidad => "Reynosa")
	 Municipio.create(:estado_id => 4, :localidad => "Acambaro")
    Municipio.create(:estado_id => 4, :localidad => "Celaya")
    Municipio.create(:estado_id => 4, :localidad => "Salvatierra")
	 Municipio.create(:estado_id => 4, :localidad => "Valle de Santiago")
	 Municipio.create(:estado_id => 5, :localidad => "Querétaro")
	 Municipio.create(:estado_id => 6, :localidad => "Soledad de Graciano")
    Municipio.create(:estado_id => 6, :localidad => "San Luis Potosí")
  end

  def self.down
    drop_table :municipios
  end
end
