class Informe < Llamada
	validates_presence_of :producto, :concepto_de_la_llamada, 
												:no_contacto, :resultado_de_la_llamada, :message => "no debe ser vacío"
end
