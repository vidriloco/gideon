class BarraInfoController < ApplicationController
	layout "unificado"
  #Método que muestra el ticket seleccionado desde la barra en una seccion independiente dentro de la página
  def desde_barra
      ticket = Ticket.find(params[:id])
      render :update do |page|
        page["vistaprev_ticket"].replace_html :partial => "ticket_prop",
            :locals => {:ticket => ticket}
        page.visual_effect :appear, "vistaprev_ticket"
      end
  end
  
  #Método que abre ó cierra un ticket usando Ajax
  def abrir
    ticket = Ticket.find(params[:id])
    if ticket.abierto
        ticket.abierto = false
      else
        ticket.abierto = true
      end
      ticket.save!
      render :update do |page|
        page["abierto"].replace_html :partial => 'abierto', :locals => {:ticket => ticket}
      end
  end
  
  #Método que marca un ticket en la sesión actual. Al cerrar la sesión se pierde este conjunto
  def marcar
    ticket = Ticket.find(params[:id])
    if ticket.marcado
      ticket.marcado = false
    else
      ticket.marcado = true
    end
    	ticket.update
      render :update do |page|
        page["marcado"].replace_html :partial => 'marcado', :locals => {:ticket => ticket}
      end
  end
  
  #Método que despliega todos los mensajes relacionados al ticket que se presenta en la página
  def mensajes_en_barra
      ticket = params[:id]
      @historiales = Historial.find_all_by_ticket_id(ticket, :order => "fecha DESC")
      render :update do |page|
        page["vistaprev_ticket"].replace_html :partial => 'mensajes_barra',
        :object => @historiales,
        :locals => {:ticket => ticket}
      end
  end
  
  def cierra_abierto_barra
      render :update do |page|
        page.visual_effect :fade, params[:id]
      end
  end
  
  def nuevo_msg
    ticket = params[:id]
    t = Ticket.find(ticket)
  	@historial = Historial.new
  	render :update do |page|
  		if t.historials.length < 1
  			page.visual_effect :blind_up, "msgvacio"
  		end
  		page["forma"].replace_html :partial => 'form_msg', :object => @historial, :locals => {:ticket => ticket}
  		page.visual_effect :appear, "forma"
  	end
  end
  
  def msg_esconde
  	ticket = Ticket.find(params[:id])
  	render :update do |page|
  		page.visual_effect :fade, "forma" 
  		if ticket.historials.blank?
  			page.visual_effect :blind_down, "msgvacio"
  		end
  	end
  end
  
  def create_msg
      @historial = Historial.new(params[:historial])
      @historial.fecha = Time.now
      @historial.save
      ticket = @historial.ticket_id
      flash[:notice] = 'Respuesta agregada'
      render :update do |page|
			 page.insert_html :top, "inferiormsg", "<div id='mensaje#{@historial.id}#{@historial.ticket_id}'><p><b>#{@historial.fecha.to_s(:long)} </b>#{@historial.mensaje}</p></div>"
			 page.visual_effect :fade, "forma" 
			 page.visual_effect :highlight, "mensaje#{@historial.id}#{@historial.ticket_id}", :duration => 4
      end
  end
  
  #Despliega la forma de modificación de ticket
  def edit_ticket
    @ticket = Ticket.find(params[:id])
	   render :update do |page|
		  	 	page["vistaprev_ticket"].replace_html :partial => "edit", :object => @ticket
	 	end
  end
  
  def mas_datos_de_ticket
  	@ticket = Ticket.find(params[:id])
	   render :update do |page|
		  	 	page["vistaprev_ticket"].replace_html :partial => "mas_datos", :object => @ticket
	 	end
  end
  
    #Muestra la vista que ofrece la posibilidad de adjuntar archivos, y ver archivos
  def archivos_ticket
  	ticket = Ticket.find(params[:id])
  	cookies[:ticket]  = {:value => params[:id]}
  	render :update do |page|
      page["vistaprev_ticket"].replace_html :partial => 'archivos',:locals => {:ticket => ticket}
    end
  end
  
  #Adjunta un nuevo archivo a este ticket 
  def adjunta
    @adjunto = Adjunto.new(params[:adjunto])
    @ticket = Ticket.find(cookies[:ticket])
    @ticket.adjuntos << @adjunto
    respond_to do |format|
	    if @adjunto.save
	      format.html { redirect_to adjunto_url }
	      format.xml  { head :created, :location => adjunto_url }
	      format.js do
	        responds_to_parent do
				    render :update do |page|
				       	if @ticket.adjuntos.length == 1
   		          	page.visual_effect :fade, "#{@ticket.id.to_s}vacio"
   		          end
   		          page.insert_html :top, "#{cookies[:ticket]}adjuntos", 
   		          :partial => "principal/controles_archivo", :locals => {:adjunto => @adjunto, 
   		          :i => 'nuevo'}
   		          page.visual_effect :highlight, "#{@adjunto.filename}#{@adjunto.id}", 
   		          :duration => 4
				    end
	        end          
	      end
	    else
	      format.xml  { render :xml => @adjunto.errors.to_xml }
	      unless @adjunto.filename.blank?
		      format.js do
		        responds_to_parent do
		          render :update do |page|
					        page["ia_error"].replace_html :partial => "resultado_archivo", :object => @adjunto
					        page.visual_effect :appear, "ia_error"
					        page.visual_effect :fade, "ia_error", :duration => 8
		          end
		        end          
		      end
	      end
	    end
  	end
  end
  
  #Permite las descargas de los archivos que han sido subidos a la base de datos
  def descarga
    @adjunto = Adjunto.find(params[:id])
    send_data(@adjunto.db_file.data, 
      :disposition => 'attachment',
      :encoding => 'utf8', 
      :type => @adjunto.content_type,
      :filename => URI.encode(@adjunto.filename)) 
  end
  
  #Elimina el archivo adjunto seleccionado
  def elimina_adjunto
  	@adjunto = Adjunto.find(params[:id])
  	@ticket = @adjunto.ticket
  	@adjunto.destroy
  	render :update do |page|
		   page.visual_effect :fade, "#{@adjunto.filename}#{@adjunto.id.to_s}"
		   if @ticket.adjuntos.length == 0
		   		page.insert_html :top, "#{@ticket.id}adjuntos", "<div id='#{@ticket.id}vacio'%><p> No hay archivos adjuntos a éste ticket </p>	</div>"
		   end 
   	end
  end
  
  #Se encarga de guardar los parámetros posiblemente actualizados de éste ticket, se excluye timestamp
  def update_ticket
    @ticket = Ticket.find(params[:id])
    ticket = params[:ticket]
    #Exclusión del hash de timestamp
    ticket.delete :timestamp 
    if @ticket.update_attributes(ticket)
      flash[:notice] = 'Ticket actualizado exitósamente.'
      render :update do |page|
		  	page["vistaprev_ticket"].replace_html :partial => "ticket_prop",
            :locals => {:ticket => @ticket}
        page.visual_effect :appear, "vistaprev_ticket", :duration => 4
	 		end
    else
      render :update do |page|
      	page["vistaprev_ticket"].replace_html :partial => "edit", :object => @ticket
      end
    end
  end
  
  def prepara_tickets(condicion, li)
  	@tickets = Ticket.find(:all, :order => "id DESC", :conditions => condicion, :limit => li)
  end
  
  def barra_informativa
	   hoy = prepara_tickets("timestamp = '#{Date.today.to_s}'", 5)
	   ayer = prepara_tickets("timestamp = '#{Date.today.to_time.yesterday.to_date.to_s}'", 5)
	   urgentes = prepara_tickets("prioridad = 'Alta' and estado = 'sin solución' and abierto = 1", 5)
	   marcados = prepara_tickets("marcado = 1", 5)
	   @objetos = Hash[:hoy => hoy, :ayer => ayer, :urgentes => urgentes, :marcados => marcados]
		 render :partial => "barra_info/barra", :object => @objetos
  end
  
  def self.arranque
	   hoy = prepara_tickets("timestamp = '#{Date.today.to_s}'", 5)
	   ayer = prepara_tickets("timestamp = '#{Date.today.to_time.yesterday.to_date.to_s}'", 5)
	   urgentes = prepara_tickets("prioridad = 'Alta' and estado = 'sin solución' and abierto = 1", 5)
	   marcados = prepara_tickets("marcado = 1", 5)
	   @objetos = Hash[:hoy => hoy, :ayer => ayer, :urgentes => urgentes, :marcados => marcados]
  end
  
  def self.prepara_tickets(condicion, li)
  	@tickets = Ticket.find(:all, :order => "id DESC", :conditions => condicion, :limit => li)
  end
  
  def paginacion_tickets(page, items_per_page, elementos)
     offset =  (page-1) * items_per_page
     @ticket_pages = Paginator.new(self, elementos.length, items_per_page, page)
     @tickets = elementos[offset..(offset + items_per_page - 1)]
     Hash[:items => @tickets, :item_pages => @ticket_pages]
  end
  
  def expande_seccion
  	case params[:id]
  		when 'a'
  			@t = prepara_tickets("timestamp = '#{Date.today.to_s}'", 100)
  			msg = "de Hoy"
  		when 'b'
  			@t = prepara_tickets("timestamp = '#{Date.today.to_time.yesterday.to_date.to_s}'", 100)
  			msg = "de Ayer"
  		when 'c'	
  			@t = prepara_tickets("prioridad = 'Alta' and estado = 'sin solución' and abierto = 1", 100)
  			msg = "Urgentes"
  		when 'd'
  			@t = prepara_tickets("marcado = 1",100)
  			msg = "Marcados"
  	end
  	@elementos = paginacion_tickets((params[:page] ||= 1).to_i,5,@t)
  	render :update do |page|
  		page["conjunto_tickets"].replace_html :partial => "ticket_conjunto", :object => @elementos, :locals => {:value => msg}
  		page.visual_effect :appear, "conjunto_tickets"
  	end
  end


end
