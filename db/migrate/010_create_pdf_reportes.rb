class CreatePdfReportes < ActiveRecord::Migration
  def self.up
    create_table :pdf_reportes do |t|
    	t.column :archivo,  :binary
    end
  end

  def self.down
    drop_table :pdf_reportes
  end
end
