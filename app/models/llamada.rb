class Llamada < ActiveRecord::Base
	
	belongs_to :cliente
	has_one :ticket
	validates_presence_of :tipo_de_llamada, :message => "no debe ser vacío"
	
	def no_contacto=(contacto)
		self.contacto = contacto
		@contacto = contacto
	end
	
	def no_contacto
		@contacto.to_s
	end
	
end
