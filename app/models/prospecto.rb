class Prospecto < Llamada

	validates_presence_of :producto, :concepto_de_la_llamada, :paquete, :cablepaquetes, :línea, :digital,
												:resultado_de_la_llamada, :no_contacto, :message => "no debe ser vacío"
	@tipo_cablepaquete = Array["Local", "Móvil", "Larga Distancia Nacional (LDN)"]
	@paquetes_video = Array["Mini-Básico","Básico","Digital","Digital Premium"]
	@paquetes_telefonia = Array["Alo 100","Alo 150","Alo Doble","Identificador de Llamadas","Control de Llamadas","Llamada en espera","Conferencia Tripartita"]
	@paquetes_internet = Array["64 kbps","256 kbps","512 kbps"]
	@digital = Array["Digital","No Digital"]
	
	def self.tipo_servicios
		return Llamada::tipo
	end 	
	
	def self.tipo_cablepaquete
		@tipo_cablepaquete
	end
	
	def self.paquetes_telefonia
		@paquetes_telefonia
	end
	
	def self.paquetes_video
		@paquetes_video
	end
	
	def self.paquetes_internet
		@paquetes_internet
	end
	
	def self.digital
		@digital
	end
end
