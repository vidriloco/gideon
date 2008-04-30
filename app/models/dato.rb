class Dato

	attr_accessor :menu_s
	attr_accessor :datos_lateral
	attr_accessor :totales

	def initialize(menu_s, datos_lateral, totales)
		if menu_s.is_a? Array and datos_lateral.is_a? Hash
			@menu_s = menu_s
			@datos_lateral = datos_lateral 
			@totales = totales
		end
	end

end
