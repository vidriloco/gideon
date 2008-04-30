#Esta clase representa una tabla, donde cada renglon contiene columnas con valores asociados a dicho
#renglón y columna
class Reporte 
	EXTENDIDO = 101
	REDUCIDO = 010
	attr_reader :titulo
	attr_reader :total
	attr_reader :estilo
	
	def self.datos_a=(datos)
		@datos_a = datos
	end
	
	def self.datos_a
		return @datos_a
	end
	
	def busca_estado(estado)
		for renglon in @renglones_reporte
			if renglon.estado.eql? estado
				return renglon
			end
		end
	end
	
	#Inicializa el arreglo que almacenará instancias de la clase RenglonReporte
	def initialize(nombre, estilo)
		@titulo = nombre
		@estilo = estilo
		@renglones_reporte	= Array.new
		@numero = 0
		@total = nil
	end
	
	#Agrega un objeto de tipo RenglonReporte al conjunto de renglones
	def agrega_renglon(renglon)
		if renglon.instance_of? RenglonReporte
			@renglones_reporte << renglon
		else
			raise ArgumentError.new("El objeto no es del tipo esperado : RenglonReporte")
		end
	end
	
	#Genera un renglon que esta identificado por la llave 'Total' y que corresponde a el total y promedio
	#total de cada columna para todos los estados
	def genera_renglon_total
		total = Hash.new
		@renglones_reporte.each do |renglon|
				renglon.columnas.keys.each do |columna|
					if total[columna].nil?
						total[columna] = {:total => renglon.columnas[columna][:total], :promedio => 0}
					else
						total[columna][:total] += renglon.columnas[columna][:total]
					end
				end
		end
		total_t = total["Total"][:total]
  	total["Total"][:promedio] = 100
		total.keys.each do |key|
			begin
				total[key][:promedio] = (total[key][:total]/total_t.to_f*100).round
			rescue
				total[key][:promedio] = 0
			end
		end
		@total = total
	end
	
	#Devuelve el conjunto de renglones
	def renglones
		@renglones_reporte
	end
	
	#Datos de grafica recibe los datos totales por columna
	def renglon_a_grafica
		genera_renglon_total
		devuelto = Hash.new
		@renglones_reporte[0].id_columnas.each do |key|
			devuelto[key] = @total[key][:promedio]
		end
		devuelto
	end
	
	#Devuelve la lista de estados de este reporte
	def estados
		devuelto = Array.new
		@renglones_reporte.each do |renglon|
			devuelto << renglon.estado
		end
		devuelto
	end
	
	#Devuelve la lista de identificadores de columnas
	def columnas
		@renglones_reporte[0].id_columnas
	end
	
	def numero=(num)
		@numero = num
	end
	
	def numero
		@numero
	end
	
end
