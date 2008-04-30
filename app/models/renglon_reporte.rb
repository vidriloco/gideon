class RenglonReporte
	#Lectura de los atributos estado, columnas
	attr_reader :estado
	attr_reader :columnas
	attr_reader :id_columnas
	attr_reader :total
	
	#Inicializacion de un objeto RenglonReporte, donde estado es el identificador del reporte
	#y total es el total de los valores de las columnas que contiene
	def initialize(estado, total)
		@estado = estado	
		@total = total
		@columnas = Hash.new
		@id_columnas = Array.new
	end
	
	def pon_total=(total)
		@total = total
	end
	
	#Agrega una columna nueva, con un valor asociada a ella, y al estado, y genera tambien
	#el promedio de esa columna
	def agrega_columna(nombre, total)
		begin
			 res = (total/@total.to_f*100).round
		rescue
			 res = 0
		end
		@columnas[nombre] = {:total => total, :promedio => res}
		@id_columnas << nombre
	end
	#Genera la columna con valor y promedio total de este RenglonReporte
	def genera_columna_total
		total, promedio = 0,0
		@columnas.keys.each do |columna| 
			total += @columnas[columna][:total]
			promedio += @columnas[columna][:promedio]
		end
		@columnas["Total"] = {:total => total, :promedio => promedio}
	end
	
end
