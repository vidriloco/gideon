class PrincipalController < ApplicationController
  before_filter :check_authentication
	layout "unificado"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pages, @collection = paginate Inflector.pluralize(@model).to_sym, :per_page => 10
  end

  def show
    @record = @model.find(params[:id])
    render :update do |page|
    	page["show"].show
    	page["show"].replace_html :partial => "principal/show", :id => @record
    end
  end

  def new
  end

  def create
    data_params = @model.to_s.downcase.to_sym
    @record = @model.new(params[data_params])
	    if @record.save
	    	@record = @model.new
	      render :update do |page|
	      	page["aviso"].replace_html :partial => "principal/exito", 
	      		:locals => {:objeto => @created_msg}
	      	page.visual_effect :toggle_appear, "aviso", :duration => 5
	      	page.visual_effect :fade, "aviso", :duration => 10 
	      	page["forma"].replace_html :partial => "new", :id => @record
	      end
	    else
	      render :update do |page|
	      	page["forma"].replace_html :partial => "new", :id => @record
	      end
	    end
  end

  def edit
    @record = @model.find(params[:id])
    render :update do |page|
	      page["forma"].replace_html :partial => "edit"
	  end
  end

  def update
    @record = @model.find(params[:id])
    if @record.update_attributes(params[@model.to_s.downcase.to_sym])
    	render :update do |page|
    		@record = @model.new
	      page["forma"].replace_html :partial => "new"
	 		end
    else
      render :update do |page|
	      	page["forma"].replace_html :partial => "edit", :id => @record
	    end
    end
  end

  def cierra_resultados
   identificador = params[:id]
  	render :update do |page|
  		page[identificador].visual_effect :fade
  	end
  end
  
  def remplaza_elemento
  	secciona = params[:id].split
  	identificador = secciona[0]
  	contenido = secciona[1]
  	adicional = secciona[2]
  	valor = secciona[3]
  	render :update do |page|
  		if adicional.nil? or valor.nil?
  			page[identificador].replace_html :partial => contenido
  		else
  			page[identificador].replace_html :partial => contenido, :locals => {adicional.to_sym => valor}
  		end
  	end
  end
  
  def encuentra_rec
  	@mensajes = Historial.dosis_mensajes
  	render :partial => "msg_recientes", :object => @mensajes
  end
  
  
end
