class LlamadasController < PrincipalController
	layout "unificado"
  def initialize
    @model = Llamada
    @created_msg = 'La llamada fue creada'
    @updated_msg = 'La llamada fue actualizada'
  end

  def list
    unless params[:id].blank?
  		cookies[:cliente] = {:value => params[:id], :expires => 160.minutes.from_now}
  	end
    @pages, @collection = paginate_collection @model.find(:all, :conditions => {:id => @cliente}), 
    :page=> params[:llamadas], :per_page => 10
    @record = Llamada.new
    @cliente = Cliente.find(params[:id] || cookies[:cliente])
	 	@agente = session[:usuario].nombre_de_usuario
  end

  def create
    @info = params[:llamada]
	  @resultado = false
		 if @info[:tipo_de_llamada] == "No Clasificable"
		 	 @prospecto = NoClasificable.new(@info)
		   @record = @prospecto
		 else
			 @prospecto = @info[:tipo_de_llamada].constantize.new(@info)
			 @prospecto.cliente_id = cookies[:cliente]
		   @record = @prospecto
		 end
		 @record.fecha_y_hora = Time.now
		 if @record.instance_of? Falla
				if @record.resultado_de_la_llamada.eql? "Se escalo a Plaza"
					@ticket = Ticket.new(params[:ticket])
					@ticket.llamada = @record
					@ticket.timestamp = Time.now
					if @record.valid? and @ticket.valid?
						if @record.save and @ticket.save
							creado_exito
						else
							error_ticket
				    end
				  else
				  	error_ticket
					end
				else
					if @record.save
						creado_exito
					else
						render :update do |page|
							page["forma"].replace_html :partial => "new", :id => @record
							page["falla"].replace_html :partial => "form_falla"
							page.visual_effect :appear, "falla"
			      end
					end
				end
		 elsif @record.instance_of? Prospecto
				 if @record.save
				 	creado_exito
				 else
				 	render :update do |page|
		      	page["forma"].replace_html :partial => "new", :id => @record
		      	page["falla"].replace_html :partial => "form_prospecto"
		      	page.visual_effect :appear, "falla"
      		end
				 end
		 elsif @record.instance_of? Otra
		 		 if @record.save
				 	creado_exito
				 else
				 	render :update do |page|
		      	page["forma"].replace_html :partial => "new", :id => @record
		      	page["falla"].replace_html :partial => "form_otra"
		      	page.visual_effect :appear, "falla"
      		end
				 end
		 elsif @record.instance_of? Informe
		 		 if @record.save
				 	creado_exito
				 else
				 	render :update do |page|
		      	page["forma"].replace_html :partial => "new", :id => @record
		      	page["falla"].replace_html :partial => "form_informe"
		      	page.visual_effect :appear, "falla"
      		end
				 end
		 elsif @record.instance_of? NoClasificable
		 		if @record.save
				 	render :update do |page|
	      		@record = Llamada.new
		      	page["aviso"].replace_html :partial => "principal/exito", 
		      			:locals => {:objeto => "Llamada guardada con éxito"}
		      	page.visual_effect :appear, "aviso", :duration => 5
		      	page.visual_effect :fade, "aviso", :duration => 5
		      	page["remplazable"].replace_html :partial => "principal/form_no_clasificable", 
		      	:object => @record
	    		end
				else
					render :update do |page|
						page["remplazable"].replace_html :partial => "principal/form_no_clasificable", 
						:object => @record
					end
				end
     end
  end

	def error_ticket
		render :update do |page|
			page["forma"].replace_html :partial => "new", :id => @record
			page["falla"].replace_html :partial => "form_falla"
			page.visual_effect :appear, "falla"
			if @record.resultado_de_la_llamada == "Se escalo a Plaza"
				 page["ticket"].replace_html :partial => "principal/form_ticket"
				 page.visual_effect :appear, "ticket"
			end
	  end
	end
	 
	def creado_exito
			@cliente = Cliente.find(cookies[:cliente])
	 	  @agente = session[:usuario].nombre_de_usuario
      render :update do |page|
      		@record = Llamada.new
	      	page["aviso"].replace_html :partial => "principal/exito", 
	      			:locals => {:objeto => "Llamada guardada con éxito"}
	      	page.visual_effect :appear, "aviso", :duration => 5
	      	page.visual_effect :fade, "aviso", :duration => 5
	      	page["forma"].replace_html :partial => "new" , :object => @record
	    end
	end

  def servicio_a_falla
		subfalla = params[:llamada][:producto]
  	render :update do |page|
  		page.replace_html 'r_subfalla', :partial => 'subfalla', :object => subfalla
  		page.replace_html 'sol_dada', :partial => 'solucion', :object => subfalla
  	end
  end
  
  def producto_a_concepto
  	concepto = params[:producto]
  	render :update do |page|
  		page.replace_html 'concepto_ll', :partial => 'concepto', :object => concepto
  	end
  end

  def prospecto_selector
  		producto = params[:producto]
  		render :update do |page|
  			page.replace_html 'prospecto_s', :partial => 'prospecto_s', :object => producto
  		end
  end

  def observador_fieldset
  	@agente = session[:usuario].nombre_de_usuario
  	case params[:llamada][:tipo_de_llamada]
  		when "Falla"
  			@record = Falla.new
  			render :update do |page|
  				page["falla"].replace_html :partial => "form_falla", :object => @record
  				page.visual_effect :appear, "falla", :duration => 1.5
  			end
  		when "Prospecto"
			 	@record = Prospecto.new
  			render :update do |page|
  			  page["falla"].replace_html :partial => "form_prospecto", :object => @record
  				page.visual_effect :appear, "falla", :duration => 1.5
  			end
  		when "Otra"
  			@record = Otra.new
  			render :update do |page|
  			  page["falla"].replace_html :partial => "form_otra", :object => @record
  				page.visual_effect :appear, "falla", :duration => 1.5
  			end
  		when "Informe"
  			@record = Informe.new
  			render :update do |page|
  			  page["falla"].replace_html :partial => "form_informe", :object => @record
  				page.visual_effect :appear, "falla", :duration => 1.5
  			end
  		else
  			render :update do |page|
  				page.visual_effect :fade, "falla", :duration => 1.5
  			end
  	end
  end
  
  def opcion_ticket
  	if params[:llamada][:resultado_de_la_llamada].eql? "Se escalo a Plaza"
  		render :update do |page|
	  		page.replace_html 'ticket', :partial => 'principal/form_ticket'
	  		page.visual_effect :appear, "ticket"
	  	end
	  else 
	  	render :update do |page|
	  		page["ticket"].hide
	  	end
  	end
  end

  def paginacion_llamada(page, items_per_page, condicion)
      offset = (page - 1) * items_per_page
      @llamadas = Llamada.find(:all, :conditions => condicion)
      @llamada_pages = Paginator.new(self, @llamadas.length, items_per_page, page)
     	@llamadas = @llamadas[offset..(offset + items_per_page - 1)]
     	Hash[:items => @llamadas, :item_pages => @llamada_pages]
  end

  def busqueda
   @final = params[:search]
   @cliente = cookies[:cliente]
	 @resultados = paginacion_llamada((params[:page] ||= 1).to_i, 4, "cliente_id = #{@cliente} and tipo_de_llamada = '#{@final}'")
	 if @resultados.blank?
	 		@resultados = paginacion_llamada((params[:page] ||= 1).to_i, 4, "cliente_id = #{@cliente} and contacto = '#{@final}'")
	 end
	 @llamadas = @resultados[:items]
	 @llamada_pages = @resultados[:item_pages]
   unless @llamadas.blank?
    render :update do |page|
    	page["resultados"].show
    	page["resultados"].replace_html :partial => 'busqueda'
    end
   else 
   	render :nothing => true
   end
  end

end
