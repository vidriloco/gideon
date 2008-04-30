class ClientesController < PrincipalController
	layout "unificado"
  def initialize
    @model = Cliente
    @created_msg = 'El cliente fue creado'
    @updated_msg = 'El cliente fue actualizado'
  end

  def busqueda
	 @final = params[:search]
	 unless @final.blank?
	 	trozos = @final.split 
	 	if trozos.length >= 2
	 		@clientes = Cliente.find(:all, 
	 		:conditions => ['nombre = ? and apellido_paterno = ? and apellido_materno = ?', trozos[0],trozos[1],trozos[2]])
	 	else
    	@clientes = Cliente.find(:all, 
    	:conditions => ['número_de_contrato = ? or teléfono_telmex = ?', @final, @final])
	 	end
	 else
	 	render :nothing => true
   end	
   
    unless @clientes.blank?
    	render :update do |page|
    		page["resultados"].show
    		page["resultados"].replace_html :partial => "busqueda"
    	end
    end
  end
  
  def observa_estado
		@municipios = Estado.busca_municipios(params[:estado])
		render :update do |page|
			page.replace_html 'localidad' , :partial => 'localidad', :object => @municipios
		end
  end
  
end
