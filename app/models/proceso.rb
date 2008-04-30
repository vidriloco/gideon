class Proceso < ActiveRecord::Base

	def self.procesos_de(tipo_llamada)
		self.find(:all, :conditions => "tipo_de_llamada = '#{tipo_llamada}' or tipo_de_llamada = 'omni'")
	end
	
	def self.procesos_nombre_de(tipo_llamada)
		@procesos= procesos_de(tipo_llamada)
		res = Array.new
		for proceso in @procesos
			res << proceso.proceso
		end
		res
	end
	
	def self.todos
		self.find(:all)
	end
	
	def self.todos_nombre
		@procesos = todos
		res = Array.new
		for proceso in @procesos
			res << proceso.proceso
		end
		res
	end
end
