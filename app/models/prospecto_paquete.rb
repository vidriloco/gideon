class ProspectoPaquete < ActiveRecord::Base

	def self.paquetes_de(servicio)
		 self.find(:all, :conditions => "servicio = '#{servicio}'")
	end
	
	def self.paquetes_con_nombre_de(producto)
		@paquetes_raw = paquetes_de(producto)
		@nombres = Array.new
		for paquete_raw in @paquetes_raw
			@nombres << paquete_raw.paquete
		end
		return @nombres
	end
	
end
