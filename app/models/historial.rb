class Historial < ActiveRecord::Base
belongs_to :ticket

	def self.dosis_mensajes
		self.find(:all, :order => "id DESC", :limit => 3)
	end
	
end
