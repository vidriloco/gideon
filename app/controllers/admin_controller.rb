class AdminController < ApplicationController
  before_filter :check_authentication, :except => [:login, :register]

	def index
		login
		render :action => 'login'
	end
	
  def login
    if request.post?
		    usuario = Usuario.find(:first, 
		    												 :conditions => ["nombre_de_usuario = ?",
		    												  params[:usuario][:nombre_de_usuario]])
		   	if usuario
		      pendiente = usuario.authenticate(params[:usuario][:contraseña])
	        session[:usuario] = usuario
	        session[:tickets] = Array.new
	        if pendiente
	        	if usuario.rol_tipo == ADMINISTRADOR
	        		redirect_to :controller => :administrador, :action => :list
	        	elsif usuario.rol_tipo == PLAZA or usuario.rol_tipo == NOC
	        		redirect_to :controller => :seguimientos_generales, :action => :list
	        	elsif usuario.rol_tipo == AGENTE
	        	  redirect_to :controller => :clientes, :action => :list
	        	elsif usuario.rol_tipo == SUPERVISOR
	        		redirect_to :controller => :reportes, :action => :principal
	        	end
	        else
	        	flash[:notice] = "Contraseña no válida"
	        end
        else
        	flash[:notice] = "Nombre de usuario no registrado"
        end
    end
  end

  def logout
    session[:usuario] = nil
    session[:tickets] = nil
    redirect_to :controller => :admin, :action => :login
  end

	def register
    if request.post?
        @usuario = Usuario.new(params[:usuario])
        if @usuario.save
 	        @usuario.agrega_rol(params[:usuario][:rol])
          render :action => 'login', :template => 'admin/login'
        end
    end
  end

end
