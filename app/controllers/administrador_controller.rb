class AdministradorController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @estado_pages, @estados = paginate :estados, :per_page => 10
    @meta_falla, @meta_fallas = paginate :meta_llamada, :per_page => 10
  end

  def show
    @estado = Estado.find(params[:id])
  end

  def new_estado
    @estado = Estado.new
    render :update do |page|
    	page["nuevo_estado"].replace_html :partial => "new_estado", :object => @estado
    	page.visual_effect :appear, "nuevo_estado"
    end
  end
  
  def new_meta_configuracion
  	  res = params[:id].split(':')
  	  tipo = res[0]
  	  selector_sera = res[1]
 	  	@meta_llamada = MetaLlamada.new
  	  render :update do |page|
  	  	if selector_sera == 'r'
  	  		page["resultado#{tipo}"].replace_html :partial => "new_meta_config", 
  	  		:locals => {:selector => selector_sera, :tipo => tipo}
  	  		page.visual_effect :appear, "resultado#{tipo}"
  	  	elsif selector_sera == 'm'
  	  		page["motivo#{tipo}"].replace_html :partial => "new_meta_config",
  	  		:locals => {:selector => selector_sera, :tipo => tipo}
  	  		page.visual_effect :appear, "motivo#{tipo}"
  	  	end
  	  end
  end
  
  def new_meta_llamada(otro=nil, antigua=nil)
  	selector = params[:id] || otro
  	@meta_llamada = MetaLlamada.new
  	render :update do |page|
  		if selector == 'num'
  			dom_obj = "metallamada_num"
  		elsif selector == 'tla'
  			dom_obj = "metallamada_tla"		
  		elsif selector == 'mtv'
  			dom_obj = "metallamada_mtv"
  		end
  		page[dom_obj].replace_html :partial => "new_meta_llamada", 
  				:object => @meta_llamada, :locals => {:opcion => selector, :dom => dom_obj}
  		if otro
  			page.insert_html :top, "lista_#{otro}", :partial => 'link_llamada', :locals => {:tupla => antigua}
  		end
  		page.visual_effect :appear, dom_obj
  	end
  end

  def create_estado
    @estado = Estado.new(params[:estado])
    @estado.save
  	render :update do |page|
  	 	page.visual_effect :fade, "nuevo_estado"
  	 	page.insert_html :bottom, "estados", 
  	 	"<div id='estado#{@estado.id}'></div>"
  	 	page["estado#{@estado.id}"].replace_html :partial => "link_estado", :object => @estado
  	 	page.visual_effect :highlight, "estado#{@estado.id}", :duration => 4
  	end
  end
  
  def create_meta_llamada
	   	@meta_llamada = MetaLlamada.new(params[:meta_llamada])
	   	particion = params[:id].split(':')	
	  	if params[:id] == 'num'
	  		@meta_llamada.selector = 1
	    elsif params[:id] == 'tla'
	    	@meta_llamada.selector = 0
	    elsif params[:id] == 'mtv'
	    	@meta_llamada.selector = 2
	    elsif particion[0] == 'r'
	    	if particion[1] == 'Otra'
	    		@meta_llamada.selector = 5
	    	else
	    		@meta_llamada.selector = 4
	    	end
	    	@meta_llamada.tipo = particion[1]
	    elsif particion[0] == 'm'
	    	@meta_llamada.selector = 3
	    	@meta_llamada.tipo = particion[1]
			end    
	   	@meta_llamada.save
	   	if particion[0] != 'm' and particion[0] != 'r'
				new_meta_llamada(params[:id], @meta_llamada)
			end
  end

  def destroy
    Estado.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def destroy_meta_llamada
  	MetaLlamada.find(params[:id]).destroy
  end
  
  def create_municipio
  		@municipio = Municipio.new(params[:municipio])
  		@municipio.save
  		render :update do |page|
  			page["nuevomun#{@municipio.estado_id}"].replace_html ""
  			page.insert_html :top, "conjunto_municipio#{@municipio.estado_id}","<div id='muni#{@municipio.estado_id}#{@municipio.id}'><h5>#{@municipio.localidad}</h5></div>"
  			page.visual_effect :highlight, "muni#{@municipio.estado_id}#{@municipio.id}", :duration => 4
  		end
  end
  
  def oculta_nuevo_municipio
  		estado = params[:id]
  		render :update do |page|
  			page["nuevomun#{estado}"].replace_html ""
  		end
  end
  
  def oculta_nuevo_x
  		dom = params[:id]
  		render :update do |page|
  			page.visual_effect :fade, dom
  		end
  end
  
  def muestra_municipio
  		estado_republica = Estado.find(params[:id])
  		@municipios_de_estado = Municipio.find_all_by_estado_id(params[:id])
  		render :update do |page|
			page["estado#{estado_republica.id}"].replace_html :partial => "muestra_municipio", :object => @municipios_de_estado, :locals => {:estado => estado_republica}
  		end
  end
  
  def ver_lista
  		res = params[:id].split(':')
  		motivo = res[0]
  		tipo = res[1]
  		mor = res[2]
  		for elemento in MetaLlamada::tipos_llamadas_nombre
  			if elemento == tipo
  				if mor == 'r'
  					opciones = Hash[1 => motivo, 2 => 'Triple']
  					@meta_llamadas = MetaLlamada::configuraciones_busqueda(4, tipo, opciones)
  				elsif mor == 'm'
  				  opciones = Hash[1 => motivo, 2 => 'Triple']
  					@meta_llamadas = MetaLlamada::configuraciones_busqueda(3, tipo, opciones)
  				end
  			end
  		end 
  		render :update do |page|
  			if mor == 'r'
					page["#{motivo}_#{tipo}_resultado"].replace_html :partial => "ver_meta_llamadas", 
								:object => @meta_llamadas, :locals => {:motivo => motivo, :tipo => tipo, :mor => mor}
				elsif mor == 'm'
					page["#{motivo}_#{tipo}_motivo"].replace_html :partial => "ver_meta_llamadas", 
								:object => @meta_llamadas, :locals => {:motivo => motivo, :tipo => tipo, :mor => mor}
				end
  		end
  end
  
  def esconde_municipio
  		estado_republica = Estado.find(params[:id])
  		render :update do |page|
				page["estado#{estado_republica.id}"].replace_html :partial => "esconde_municipio",
						 :locals => {:estado => estado_republica}
  		end
  end
  
  
  def esconde_lista
  		res = params[:id].split(':')
  		motivo = res[0]
  		tipo = res[1]
  		mor = res[2]
  		render :update do |page|
  			if mor == 'm'
  				page["#{motivo}_#{tipo}_motivo"].replace_html :partial => "link_falla", 
  				:locals => {:motivo => motivo, :tipo => tipo, :mor => mor}
  			elsif mor == 'r'
  				page["#{motivo}_#{tipo}_resultado"].replace_html :partial => "link_falla", 
  				:locals => {:motivo => motivo, :tipo => tipo, :mor => mor}
  			end
  		end
  end
  
  def nuevo_municipio
  	   @municipio = Municipio.new
  	   estado = params[:id]
  	   render :update do |page|
  	   	page["nuevomun#{estado}"].replace_html :partial => "mun_form", :object => @municipio, :locals => {:estado => estado}
  	   end
  end
  
  def register
    if request.post?
        @usuario = Usuario.new(params[:usuario])
        if @usuario.save
        	@usuario.agrega_rol(params[:usuario][:rol])
 	        render :update do |page|
 	        	page["registrop"].replace_html :partial => "register"
 	        end
        else
        	render :update do |page|
 	        	page["registrop"].replace_html :partial => "register", :object => @usuario
 	        end
        end
    end
  end
  
end
