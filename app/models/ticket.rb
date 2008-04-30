class Ticket < ActiveRecord::Base
	belongs_to :llamada
	belongs_to :usuario
	has_many :historials
	has_many :adjuntos
	
#	acts_as_attachment  :storage => :db_system, 
#                  		:max_size => 1.megabytes,

  #validates_as_attachment
	validates_presence_of :prioridad, :estado, :enviar_a, :message => "no debe ser vacío"
 	@estado_ticket = ["Solucionado","Sin Solución","Sin Respuesta"]
 	@prioridad = ["Alta","Media","Baja"]	
	
# def adjunto=(archivo_adjunto)
#	  return if archivo_adjunto.blank?
#	  self.adjunto = archivo_adjunto.read
# end
#  	def usuario_id
#  		unless self.new_record?
#  			if self[:usuario_id].blank?
#				self.usuario_id = "   "
#			else
#				self.usuario_id = Usuario.find(self[:usuario_id]).nombre_de_usuario
#			end
#		end
 # 	end
  	
 # 	def usuario_id=(seleccionado)
 # 		unless seleccionado.blank?
 #	  		self[:usuario_id] = Usuario.find_by_nombre_de_usuario(seleccionado).id 
 #	  	end
 # 	end

 	def self.estado_ticket
 		@estado_ticket
 	end
 	
 	def self.prioridad
 		@prioridad
 	end

 	def self.varios(condiciones)
 		@tickets = Ticket.find(:all, :order => "id DESC")
 		@hoy, @ayer, @urgentes, @marcados = Array.new, Array.new, Array.new, Array.new
 		for ticket in @tickets
 			if ticket.timestamp.to_s == Date.today.to_s
 				@hoy << ticket
 			elsif ticket.timestamp.to_s == Date.today.to_time.yesterday.to_date.to_s
 				@ayer << ticket			
 			end
 			if ticket.prioridad == "Alta" and ticket.abierto
				@urgentes << ticket
			end
			if ticket.marcado
 				@marcados << ticket
 			end
 		end
 		return Hash[:hoy => @hoy, :ayer => @ayer, :urgente => @urgentes, :marcado => @marcados]
 	end
 	
end
