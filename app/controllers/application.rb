# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
  require 'iconv' 
class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_gideon_session_id'
	helper :errors

  def to_iso(cadena)  
     c = Iconv.new('ISO-8859-15','UTF-8')  
     c.iconv(cadena)  
  end 


	# paginate_collection [Collection, opciones {:per_page, :page}]
	# Método que se encarga de paginar los elementos que se le pasen cómo parámetro.
	# Estos elementos son colecciones (i.e Array)

  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options
    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end

  def repara_utf8(cadena)
	  cadena = cadena.gsub("%C3%A1", "á")
	  cadena = cadena.gsub("%C3%81", "Á")
	  cadena = cadena.gsub("%C3%A9", "é")
	  cadena = cadena.gsub("%C3%89", "É")
	  cadena = cadena.gsub("%C3%AD", "í")
	  cadena = cadena.gsub("%C3%8D", "Í")
	  cadena = cadena.gsub("%C3%B3", "ó")
	  cadena = cadena.gsub("%C3%93", "Ó")
	  cadena = cadena.gsub("%C3%BA", "ú")
	  cadena = cadena.gsub("%C3%9A", "Ú")
	  cadena = cadena.gsub("%C3%B1", "ñ")
	  cadena = cadena.gsub("%C3%91", "Ñ")
  end

  def repara_request(cadena)
	  cadena = cadena.gsub("=","")
	  cadena = cadena.gsub("%20"," ")
  end
  
  private
  def check_authentication
    if session[:usuario].blank?
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
  

end
