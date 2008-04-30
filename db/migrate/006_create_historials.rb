class CreateHistorials < ActiveRecord::Migration
  def self.up
    create_table :historials do |t|
    	t.column :ticket_id, 		:integer, :null => false
    	t.column :dueno,				:string
    	t.column :fecha, 			:datetime, :default => Time.now
    	t.column :mensaje,			:string
    end
  end

  def self.down
    drop_table :historials
  end
end
