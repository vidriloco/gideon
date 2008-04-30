class Estado < ActiveRecord::Base
	has_many :municipios
	
	def self.estados
 		todos_los_estados = self.find(:all)
		@estados = Array.new
		for estado in todos_los_estados
	       @estados << estado.estado
		end
		@estados
	end
	
	def self.busca_municipios(estado)
		estado = self.find_by_estado(estado)
		@nuevos_municipios = estado.municipios
		@municipios = Array.new
		for municipio in @nuevos_municipios
			@municipios << municipio.localidad
		end
		@municipios
	end
	
end
