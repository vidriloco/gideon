class CreateMetaLlamadas < ActiveRecord::Migration
  def self.up
    create_table :meta_llamadas do |t|
    	t.column  :selector,   		:integer #0- modificacion_tipos, #1- modificacion_numeros, 2- motivos 3- selecciones, 4- resultado, 5- tipo de llamadas 'secas' <tienen solamente campo resultado >
    	t.column	:tipo,						:string #Tipo de la Llamada : Prospecto, Falla, Informe, Otra
    	t.column 	:motivo,					:string #Internet, Telefonia, Television, Triple
  		t.column	:razon, 				  :string 
  		t.column	:resultado,		  :string # En que termino la llamada
  		t.column  :tipo_de_tipos, :string #Opciones definidas para tipo 
  		t.column  :numeros, 			:integer #Numeros definidos
  		t.column  :m_de_motivos,   :string #Opciones de motivos de llamada
    end
    
    MetaLlamada.create(:selector => 0, :tipo_de_tipos => "Prospecto")
    MetaLlamada.create(:selector => 0, :tipo_de_tipos => "Falla")
    MetaLlamada.create(:selector => 0, :tipo_de_tipos => "Otra")
    MetaLlamada.create(:selector => 0, :tipo_de_tipos => "Informe")
    
    MetaLlamada.create(:selector => 1, :numeros => "01800")
    MetaLlamada.create(:selector => 1, :numeros => "050")
    
    MetaLlamada.create(:selector => 2, :m_de_motivos => "Internet")
    MetaLlamada.create(:selector => 2, :m_de_motivos => "Telefonía")
    MetaLlamada.create(:selector => 2, :m_de_motivos => "Televisión")
    
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Internet", :razon => "Sin señal")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Internet", :razon => "Quejas")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Televisión", :razon => "Sin señal básico")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Televisión", :razon => "Sin señal digital")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Televisión", :razon => "No se ven canales")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Televisión", :razon => "Mala calidad de imagen")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "Identificador de Llamadas")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "Control de Llamadas")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No puede comunicarse a números Nextel")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No recibe llamadas internacionales")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No recibe llamadas desde las Vegas")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "Sin línea")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No puede llamar a teléfono local")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No recibe llamadas")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No puede marcar")
    MetaLlamada.create(:selector => 3, :tipo => "Falla", :motivo => "Telefonía", :razon => "No da tono")  
    MetaLlamada.create(:selector => 4, :tipo => "Falla", :motivo => "Triple", :resultado => "Check out exitoso")
    MetaLlamada.create(:selector => 4, :tipo => "Falla", :motivo => "Triple", :resultado => "Se escalo a Plaza")
    MetaLlamada.create(:selector => 4, :tipo => "Falla", :motivo => "Triple", :resultado => "Se informó cómo utilizar el servicio")
    MetaLlamada.create(:selector => 4, :tipo => "Falla", :motivo => "Internet", :resultado => "Configuración del sistema")
    
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Triple", :razon => "Cobertura")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Internet", :razon => "Velocidades")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Triple", :razon => "Tarifas y Precios")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Triple", :razon => "Descuentos")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Televisión", :razon => "Básico")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Televisión", :razon => "Digital")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Televisión", :razon => "Premium")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Televisión", :razon => "No se ha instalado servicio")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Paquetes Básicos")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Cablepaquetes")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Soluciones")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "ALO 100")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "ALO 150")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "ALO Doble")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Identificador de Llamadas")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Control de Llamadas")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Aclaración de Dudas")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Tarifas por minuto")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Seguimiento a Reporte")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "Desvio de Llamadas")
    MetaLlamada.create(:selector => 3, :tipo => "Informe", :motivo => "Telefonía", :razon => "No se ha instalado servicio")
    
    MetaLlamada.create(:selector => 4, :tipo => "Informe", :motivo => "Triple", :resultado => "Se resolvió")
    MetaLlamada.create(:selector => 4, :tipo => "Informe", :motivo => "Triple", :resultado => "Call Back para brindar respuesta")
    MetaLlamada.create(:selector => 4, :tipo => "Informe", :motivo => "Triple", :resultado => "Se solicitó información a la plaza")
    MetaLlamada.create(:selector => 3, :tipo => "Prospecto", :motivo => "Triple", :razon => "Venta")
    MetaLlamada.create(:selector => 3, :tipo => "Prospecto", :motivo => "Triple", :razon => "Sin Cobertura")
    MetaLlamada.create(:selector => 3, :tipo => "Prospecto", :motivo => "Triple", :razon => "Agendada")
    MetaLlamada.create(:selector => 3, :tipo => "Prospecto", :motivo => "Triple", :razon => "Prospecto")
    MetaLlamada.create(:selector => 4, :tipo => "Prospecto", :motivo => "Triple", :resultado => "Venta")
    MetaLlamada.create(:selector => 4, :tipo => "Prospecto", :motivo => "Triple", :resultado => "No Venta")
    MetaLlamada.create(:selector => 4, :tipo => "Prospecto", :motivo => "Triple", :resultado => "Sin Cobertura")
    MetaLlamada.create(:selector => 5, :tipo => "Otra", :resultado => "Colgaron")
    MetaLlamada.create(:selector => 5, :tipo => "Otra", :resultado => "Ubicación y Teléfonos de Sucursal")
    MetaLlamada.create(:selector => 5, :tipo => "Otra", :resultado => "Llamada de Prueba")
    MetaLlamada.create(:selector => 5, :tipo => "Otra", :resultado => "Se corta la Llamada")
    
    MetaLlamada.create(:selector => 5, :tipo => "No Clasificable", :resultado => "Se corta la Llamada")
    MetaLlamada.create(:selector => 5, :tipo => "No Clasificable", :resultado => "Llamada de Prueba")
    MetaLlamada.create(:selector => 5, :tipo => "No Clasificable", :resultado => "Nadie contesta")
    MetaLlamada.create(:selector => 5, :tipo => "No Clasificable", :resultado => "Equivocado")
    MetaLlamada.create(:selector => 5, :tipo => "No Clasificable", :resultado => "Colgaron")
    MetaLlamada.create(:selector => 5, :tipo => "No Clasificable", :resultado => "Broma")
  end

  def self.down
    drop_table :meta_llamadas
  end
end
