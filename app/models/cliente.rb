class Cliente < ActiveRecord::Base

	has_many :llamadas
	validates_numericality_of :teléfono_alo, :número_de_contrato, :teléfono_telmex,
									  :message => "deben ser numérico", :allow_nil => true
	validates_presence_of :teléfono_telmex, :nombre, :apellido_paterno, :apellido_materno,
												:calle, :número_exterior, :colonia, :código_postal, :municipio, :estado,
												:message => "no debe ser vacío"
	validates_uniqueness_of :número_de_contrato, :message => "ya registrado"
	
	
	def nombre_completo
		self.nombre + " " + self.apellido_paterno + " " + self.apellido_materno
	end
end
