class NoClasificable < Llamada
	validates_presence_of :concepto_de_la_llamada, :message => "no debe ser vacío"
end
