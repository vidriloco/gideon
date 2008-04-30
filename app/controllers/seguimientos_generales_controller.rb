class SeguimientosGeneralesController < ApplicationController

  def paginacion_todos(page, items_per_page)
     offset = (page - 1) * items_per_page
     @tickets = Ticket.find(:all)
     @ticket_pages = Paginator.new(self, @tickets.length, items_per_page, page)
     @tickets = @tickets[offset..(offset + items_per_page - 1)]
     Hash[:items => @tickets, :item_pages => @ticket_pages]
  end

  def paginacion_ticket(page, items_per_page, condicion)
      offset = (page - 1) * items_per_page
      @tickets = Ticket.find(:all, :conditions => condicion)
      @ticket_pages = Paginator.new(self, @tickets.length, items_per_page, page)
     	@tickets = @tickets[offset..(offset + items_per_page - 1)]
     	Hash[:items => @tickets, :item_pages => @ticket_pages]
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  end

  def show
    @ticket = Ticket.find(params[:id])
    render :update do |page|
          page["seccion"].replace_html :partial => "show", :object => @ticket
   end
  end

  def mensajes
       ticket = params[:id]
      @historiales = Historial.find_all_by_ticket_id(ticket, :order => "fecha DESC")
      render :update do |page|
        page["elemento#{ticket}"].replace_html :partial => 'mensajes', :object => @historiales,
        :locals => {:ticket => ticket}
      end
  end

  def mensajes_esconde
      ticket = params[:id]
      render :update do |page|
          page.visual_effect :fade, "msg#{ticket}"
        page["elemento#{ticket}"].replace_html :partial => 'ocultar', :locals => {:ticket => ticket}
      end
  end

  def n_msg
      ticket = params[:id]
      @historial = Historial.new
      render :update do |page|
        page["msg#{ticket}"].replace_html :partial => 'form_msg', :object => @historial, :locals => {:ticket => ticket}
        page.visual_effect :appear, "msg#{ticket}"
      end
  end

  def create_msg
      @historial = Historial.new(params[:historial])
      @historial.save
      ticket = @historial.ticket_id
      flash[:notice] = 'Respuesta agregada'
      render :update do |page|
      page.insert_html :top, "msg", "<div id='compuesto#{@historial.id}#{@historial.ticket_id}'><p><b>#{@historial.fecha.to_s(:long)} </b>#{@historial.mensaje}</p></div>"
      page.visual_effect :fade, "msg#{ticket}"
      page.visual_effect :highlight, "compuesto#{@historial.id}#{@historial.ticket_id}", :duration => 4
      end
  end

  def n_esconde
      ticket = params[:id]
      render :update do |page|
        page.visual_effect :fade, "msg#{ticket}"
      end
  end

  def mixto
    numero = params[:id]
    case numero
        #Caso para mostrar la lista de tickets ["Tickets"]
      when 'a'
      	usuario = session[:usuario]
      	if usuario.rol_tipo == NOC
      		paginacion = paginacion_todos((params[:page] ||= 1).to_i, 5)
      	else
        	paginacion = paginacion_ticket((params[:page] ||= 1).to_i, 5, "enviar_a = '#{usuario.nombre_de_usuario}'")
        end
         @tickets = paginacion[:items]
         @ticket_pages = paginacion[:item_pages]
         render :update do |page|
          page["seccion"].replace_html :partial => "sublista", :object => @tickets
         end
      #Caso para mostrar los tickets abiertos y cerrados ["Abiertos & Cerrados"]
      when 'b'
        render :update do |page|
          page["seccion"].replace_html :partial => "abiertos_cerrados"
        end
    end
  end

  def busqueda
      render :update do |page|
        page["seccion"].replace_html :partial => "busqueda", :object => @tickets
    end
  end

  #Metodo que recarga la opcion de busqueda en un div "opciones_busqueda"
  def controles_busqueda
      que_desplegar = params[:id]
    case que_desplegar
      when 'a'
       render :update do |page|
        page["opciones_busqueda"].replace_html :partial => "busqueda_controles", :locals => { :cv => 'a' }
        page.toggle "opciones_busqueda"
        page.visual_effect :appear, "opciones_busqueda"
     end
      when 'b'
       render :update do |page|
        page["opciones_busqueda"].replace_html :partial => "busqueda_controles", :locals => { :cv => 'b' }
        page.toggle "opciones_busqueda"
        page.visual_effect :appear, "opciones_busqueda"
     end
      when 'c'
     render :update do |page|
        page["opciones_busqueda"].replace_html :partial => "busqueda_controles", :locals => { :cv => 'c' }
        page.toggle "opciones_busqueda"
        page.visual_effect :appear, "opciones_busqueda"
     end
  end
  end

  def busqueda_bajo_nivel

  end

  #Método encargado de mostrar el conjunto de tickets abiertos/cerrados
  def abrir_cerrar
      estado = params[:id]
      usuario = session[:usuario]
      case estado
        when 'a'
 	      	if usuario.rol_tipo == NOC
          	@paginacion = paginacion_ticket((params[:page] ||= 1).to_i, 5, "abierto = 1")
          else
          	@paginacion = paginacion_ticket((params[:page] ||= 1).to_i, 5, 
          																	"abierto = 1 and enviar_a = '#{usuario.nombre_de_usuario}'")
          end
          @co_tickets = Hash[:items => @paginacion[:items], :item_pages => @paginacion[:item_pages]]
      		render :update do |page|
        		page["estado"].replace_html :partial => "ab_ce_ticket", 
        																 :object => @co_tickets, :locals => {:conjunto => "abiertos"}
      		end
        when 'b'
        	if usuario.rol_tipo == NOC
          	@paginacion = paginacion_ticket((params[:page] ||= 1).to_i, 5, "abierto = 0")
          else
          	@paginacion = paginacion_ticket((params[:page] ||= 1).to_i, 5, 
          																	"abierto = 0 and enviar_a = '#{usuario.nombre_de_usuario}'")
          end
        	@co_tickets = Hash[:items => @paginacion[:items], :item_pages => @paginacion[:item_pages]]
      		render :update do |page|
        		page["estado"].replace_html :partial => "ab_ce_ticket", 
        																 :object => @co_tickets, :locals => {:conjunto => "cerrados"}
      		end
      end
  end
  
  def detalle_ticket
  	if params[:id] == 'a'
  	  @ticket = Ticket.find(params[:locals][:ti])
	  	render :update  do |page|
	  		page["show"].replace_html :partial => "detalle_ticket", :object => @ticket
	  		page.visual_effect :appear, "show"
	  	end
	  elsif params[:id] == 'b'
	  	render :update  do |page|
	  	page.visual_effect :fade, "show"
	  	end
	  end
  end
  
  #Metodo que realiza el despliegue de la sección correspondiente a la lista de archivos adjuntos
  def archivos_listado
  	ticket = Ticket.find(params[:id])
  	cookies[:ticket] = {:value => params[:id]}
  	render :update do |page|
      page["elemento#{params[:id]}"].replace_html :partial => 'archivos', 
      :locals => {:ticket => ticket}
    end
  	
  end
  
end
