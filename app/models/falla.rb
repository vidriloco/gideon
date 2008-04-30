class Falla < Llamada
	
	validates_presence_of :no_reporte, :concepto_de_la_llamada, :producto, 
			      					  :fecha_de_solución, :no_contacto, :resultado_de_la_llamada,
												:message => "no debe ser vacío"
  
	def self.genera_numero(agente)
		#Obtener el tiempo actual (Mes/Dia/Año/Hora/Minuto)
		tiempo_actual = Time.now.strftime("%m%d%Y%H%M")
 		aleatorio = rand(999).to_s()
		final = tiempo_actual + agente + aleatorio
		return final		
	end 
	
	def self.reporte_fallas_condiciones(condiciones)
		@resultados = self.find(:all, :conditions => condiciones)
		@llamadas = Array.new
		for resultado in @resultados
			@llamadas << resultado
		end
		@llamadas
	end
	
	def self.reporte_fallas
		@resultados = self.find(:all)
		@llamadas = Array.new
		for resultado in @resultados
			@llamadas << resultado
		end
		@llamadas
	end
	

end
