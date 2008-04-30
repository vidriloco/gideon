class MetaLlamada < ActiveRecord::Base

	#Obtiene las tuplas que describen numeros de Llamada (EJ 01800, 050, ..)
	def self.numeros
		self.find(:all, :conditions => "selector = 1")
	end
	
	#Da un arreglo con los numeros de Llamada
	def self.numeros_nombre
		@numeros = self.numeros
		n_arreglo = Array.new
		for numero in @numeros
			n_arreglo << numero.numeros
		end
		n_arreglo
	end
	
	#Obtiene las tuplas que describen un tipo de llamada (EJ Prospecto, Falla, Otra, ..)
	def self.tipos_llamadas
		self.find(:all, :conditions => "selector = 0")
	end
	
	#Da un arreglo con los tipos de llamadas
	def self.tipos_llamadas_nombre
		@llamadas = self.tipos_llamadas
		l_arreglo = Array.new
		for llamada in @llamadas
			l_arreglo << llamada.tipo_de_tipos
		end
		l_arreglo
	end
	
		#Obtiene las tuplas que describen un motivo (EJ Internet, Video, ..)
	def self.m_motivos
		self.find(:all, :conditions => "selector = 2")
	end
	
	#Da un arreglo con los motivos
	def self.motivos_nombre
		@motivos = self.m_motivos
		l_arreglo = Array.new
		for motivo in @motivos
			l_arreglo << motivo.m_de_motivos
		end
		l_arreglo
	end
	
	#Obtiene las tuplas que cumplan que motivo es internet <tipo> = [prospecto, falla, ..]
	def self.configuraciones_busqueda(no, tipo, opciones=nil)
		if opciones.nil?
			condiciones = "selector = #{no} and tipo = '#{tipo}'"
		else
			if opciones[2].nil?
				condiciones = "selector = #{no} and tipo = '#{tipo}' and motivo = '#{opciones[1]}'"
			else
				condiciones = "(selector = #{no} and tipo = '#{tipo}' and motivo = '#{opciones[1]}') or (selector = #{no} and tipo = '#{tipo}' and motivo = '#{opciones[2]}')"
			end
		end
		self.find(:all, :conditions => condiciones)
	end
	
	#Da un arreglo con las razones de internet
	def self.configuraciones_nombre(no,obj, tipo, opciones=nil)
		objetos = self.configuraciones_busqueda(no,tipo,opciones)
		@res = Array.new
		for o in objetos
			if obj.eql? 'm'
				@res << o.razon
			elsif obj.eql? 'r' or obj.eql? 'o'
				@res << o.resultado
			end
		end
		@res
	end
	
	def self.configuraciones_falla_internet
		configuraciones_nombre(3, 'm', "Falla", {1 => "Internet"})
	end
	
	def self.configuraciones_falla_television
		configuraciones_nombre(3, 'm', "Falla", {1 => "Televisión"})
	end
	
	def self.configuraciones_falla_telefonia
		configuraciones_nombre(3, 'm', "Falla", {1 => "Telefonía"})
	end
	
	def self.configuraciones_falla(opcion)
		configuraciones_nombre(3, 'm', "Falla", {1 => "#{opcion}"})
	end
	
	def self.configuraciones_otra
		configuraciones_nombre(5, 'r', "Otra")
	end
	
	def self.configuraciones_no_clasificable
		configuraciones_nombre(5, 'r', "No Clasificable")
	end
	
	def self.configuraciones(tipoll, opcion, res)
		if res.eql? 'Razones'
			configuraciones_nombre(3, 'm', "#{tipoll}", {1 => "#{opcion}", 2 => "Triple"})
		elsif res.eql? 'Resultados'
			configuraciones_nombre(4, 'r', "#{tipoll}", {1 => "#{opcion}", 2 => "Triple"})
		end
	end
	

end
