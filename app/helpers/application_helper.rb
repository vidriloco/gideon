# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  
  def pagination_links_remote(paginator)
	  page_options = {:window_size => 1}
	  pagination_links_each(paginator, page_options) do |n|
	    options = {
	      :url => {:action => 'list', :params => @params.merge({:page => n})},
	      :update => 'table',
	    }
	    html_options = {:href => url_for(:action => 'list', :params => @params.merge({:page => n}))}
	    link_to_remote(n.to_s, options, html_options)
	  end
	end
	
	def pagination_links_remote_no_update(paginator)
	  page_options = {:window_size => 1}
	  pagination_links_each(paginator, page_options) do |n|
	    options = {
	      :url => { :params => params.merge({:page => n, :controller => 'barra_info', :action => 'expande_seccion'})}
	    }
	    html_options = {:href => url_for(:params => params.merge({:page => n, :controller => 'barra_info', :action => 'expande_seccion'}))}
	    link_to_remote(n.to_s, options, html_options)
	  end
	end
	
	def limita_msg(cadena)
		return cadena[0,22] + "..."
	end
	  
end
