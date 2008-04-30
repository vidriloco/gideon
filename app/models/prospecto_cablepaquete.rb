class ProspectoCablepaquete < ActiveRecord::Base

	def self.cablepaquetes
		self.find(:all)
	end
	
	def self.cablepaquetes_nombre
		@cablpqts = cablepaquetes
		@nombres = Array.new
		for cablpqt in @cablpqts
			@nombres << cablpqt.cablepaquete
		end
		return @nombres
	end
	
end
