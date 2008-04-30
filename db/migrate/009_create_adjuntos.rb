class CreateAdjuntos < ActiveRecord::Migration
  def self.up
    create_table :adjuntos do |t|
      t.column :content_type, 	:string
      t.column :filename, 			:string     
      t.column :size, 						:integer
      
      # used with thumbnails, always required
      t.column :parent_id,  		:integer 
      t.column :thumbnail, 			:string

      # required for db-based files only
      t.column :db_file_id, 		:integer
      
      #Ligado a Ticket
      t.column :ticket_id, 			:integer
    end

    # only for db-based files
     create_table :db_files, :force => true do |t|
          t.column :data, 				:binary
     end
  end

  def self.down
    drop_table :adjuntos
    
    # only for db-based files
     drop_table :db_files
  end
end
