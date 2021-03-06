require 'pdf/writer'  
require 'pdfwriter_extensions'

class ReportesController < ApplicationController
	
	#Genere la gráfica de pastel o de barras relacionada a los datos y al titulo_g que pasan cómo parámetro.
	def reporte_grafica(titulo_g, datos)
	  g = Gruff::Bar.new("600x500")
	  g.title = titulo_g
	  g.margins = 50
	  g.marker_count = 10
	 	g.font = File.expand_path 'artwork/fonts/Vera.ttf', RAILS_ROOT
	  for key in datos.keys
      g.data(key.to_s, [datos[key]])
		end
		g.maximum_value=100
		g.minimum_value=0
		g.x_axis_label
		g.y_axis_label
		g.marker_color = "#525252"
		g.write 'public/images/generadas/img.jpg'
  end
  
  	
	def genera_pdf
		 info = session[:actual_datos]
 		 p = PDF::Writer.new(:paper => "A4")
 		 p.select_font('Helvetica-Oblique', :encoding => nil)
 		 p.text info.titulo.upcase, :font_size => 15, :spacing => 3, :justification => :center
 	   if info.estilo == Reporte::REDUCIDO
		 	 p = pdf_reducido(info, p)
 	   else
		 	 p =	pdf_extenso(info, p)
		 end
 		 p.image "public/images/generadas/img.jpg", :justification => :center, :resize => 0.60
	   send_data p.render, :filename => info.titulo , :type => "application/pdf" 
	end
	
	#Metodo que establece rangos de tiempo en formato Date, para realizar extracciones sobre fechas determinadas
	def establece_intervalos(t_extraccion, rango)
		if t_extraccion == "Acumulados de Hoy"
			inicio = Time.now.midnight
			final = Time.now.midnight.tomorrow
		elsif t_extraccion == "Rango de Tiempo"
			inicio = Date.new(rango[:año_i].to_i, rango[:dia_i].to_i, rango[:mes_i].to_i).to_time.midnight
			final = Date.new(rango[:año_f].to_i, rango[:dia_f].to_i, rango[:mes_f].to_i).to_time.midnight.tomorrow
		else
			inicio = nil
			final = nil
		end
		if inicio.nil? and final.nil?
			return Hash[:inicio => inicio, :final => final]
		else
			return Hash[:inicio => inicio.to_s(:db), :final => final.to_s(:db)]
		end
	end
	
	def informe
		tipo_llamada = "Informe"
		rango_fecha = Hash[:año_f => params[:reporte]["final(1i)"],
												:mes_f => params[:reporte]["final(3i)"],
												:dia_f => params[:reporte]["final(2i)"],
												:año_i => params[:reporte]["inicio(1i)"],
												:mes_i => params[:reporte]["inicio(3i)"],
												:dia_i => params[:reporte]["inicio(2i)"]]
		res = establece_intervalos(params[:reporte][:rango], rango_fecha)
		producto = params[:reporte][:producto]
		aspecto = params[:reporte][:aspecto]
		if aspecto.eql? 'Resultados'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "resultado_de_la_llamada"}
		elsif aspecto.eql? 'Razones'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "concepto_de_la_llamada"}
		end
 	  titulo = tipo_llamada + "::" + aspecto + ":" + producto #Título que aparecerá en la gráfica
 	  listado = MetaLlamada.configuraciones(tipo_llamada, producto, aspecto)
		procesa_llamada(listado, res, tipo_llamada, opciones, titulo, producto)
	end
	
	def falla
		tipo_llamada = "Falla"
		rango_fecha = Hash[:año_f => params[:reporte]["final(1i)"],
												:mes_f => params[:reporte]["final(3i)"],
												:dia_f => params[:reporte]["final(2i)"],
												:año_i => params[:reporte]["inicio(1i)"],
												:mes_i => params[:reporte]["inicio(3i)"],
												:dia_i => params[:reporte]["inicio(2i)"]]
		res = establece_intervalos(params[:reporte][:rango], rango_fecha)
		producto = params[:reporte][:producto]
		aspecto = params[:reporte][:aspecto]
		if aspecto.eql? 'Resultados'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "resultado_de_la_llamada"}
		elsif aspecto.eql? 'Razones'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "concepto_de_la_llamada"}
		end
 	  titulo = tipo_llamada + "::" + aspecto + ":" + producto #Título que aparecerá en la gráfica
 	  listado = MetaLlamada.configuraciones(tipo_llamada, producto, aspecto)
		procesa_llamada(listado, res, tipo_llamada, opciones, titulo, producto)
	end
	
	def otra
		tipo_llamada = "Otra"
		rango_fecha = Hash[:año_f => params[:reporte]["final(1i)"],
												:mes_f => params[:reporte]["final(3i)"],
												:dia_f => params[:reporte]["final(2i)"],
												:año_i => params[:reporte]["inicio(1i)"],
												:mes_i => params[:reporte]["inicio(3i)"],
												:dia_i => params[:reporte]["inicio(2i)"]]
		opciones = {:opcion1 => "resultado_de_la_llamada"}
		res = establece_intervalos(params[:reporte][:rango], rango_fecha)
 	  listado = MetaLlamada.configuraciones_otra
		procesa_llamada(listado, res, tipo_llamada, opciones, "Otra", nil)
	end
	
	def prospecto
		tipo_llamada = "Prospecto"
		rango_fecha = Hash[:año_f => params[:reporte]["final(1i)"],
												:mes_f => params[:reporte]["final(3i)"],
												:dia_f => params[:reporte]["final(2i)"],
												:año_i => params[:reporte]["inicio(1i)"],
												:mes_i => params[:reporte]["inicio(3i)"],
												:dia_i => params[:reporte]["inicio(2i)"]]
		res = establece_intervalos(params[:reporte][:rango], rango_fecha)
		producto = params[:reporte][:producto]
		aspecto = params[:reporte][:aspecto]
		if aspecto.eql? 'Resultados'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "resultado_de_la_llamada"}
			listado = MetaLlamada.configuraciones(tipo_llamada, producto, aspecto)
			titulo = tipo_llamada + "::" + aspecto + ":" + producto #Título que aparecerá en la gráfica
		elsif aspecto.eql? 'Razones'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "concepto_de_la_llamada"}
			listado = MetaLlamada.configuraciones(tipo_llamada, producto, aspecto)
			titulo = tipo_llamada + "::" + aspecto + ":" + producto #Título que aparecerá en la gráfica
		elsif aspecto.eql? 'Paquetes'
			opciones = {:opcion1 => "producto", :opcion2 => producto.downcase, 
									:opcion3 => "paquete"}
	 	  listado = ProspectoPaquete.paquetes_con_nombre_de(producto)
	 	  titulo = tipo_llamada + "::" + aspecto + ":" + producto #Título que aparecerá en la gráfica
	 	elsif aspecto.eql? 'Cablepaquetes'
	 		opciones = {:opcion1 => "cablepaquetes"}
	 	  listado = ProspectoCablepaquete.cablepaquetes_nombre
	 	  titulo = tipo_llamada + "::" + aspecto #Título que aparecerá en la gráfica
	 	  producto = nil
		end
 	  
		procesa_llamada(listado, res, tipo_llamada, opciones, titulo, producto)
	end
	
	def general
		rango_fecha = Hash[:año_f => params[:reporte]["final(1i)"],
												:mes_f => params[:reporte]["final(3i)"],
												:dia_f => params[:reporte]["final(2i)"],
												:año_i => params[:reporte]["inicio(1i)"],
												:mes_i => params[:reporte]["inicio(3i)"],
												:dia_i => params[:reporte]["inicio(2i)"]]
		res = establece_intervalos(params[:reporte][:rango], rango_fecha)
				 opcion1 = "Orígen de Llamadas"
				 opcion2 = "Motivo de Llamada"
				 opcion3 = "Razones de Telefonía"
				 opcion4 = "Razones de Televisión"
				 opcion5 = "Razones de Internet"
				 opcion6 = "No Clasificables"
				 opcion7 = "Ordenes"
		 case params[:reporte][:general]
		 		when opcion1		
		 			@datos = proc_esp(MetaLlamada::tipos_llamadas_nombre, opcion1 , res, Llamada,
		 			{:opcion1 => "tipo_de_llamada"}, opcion1, Reporte::EXTENDIDO)
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_v", :object => @datos, 
	  						:locals => {:escenario => opcion1}
	  				page.visual_effect :appear, "cambiante"
	  			end
		 		when opcion2
		 			@datos = motivos_detalle_en_television(MetaLlamada::motivos_nombre, res,
		 			Llamada,	{:opcion1 => "producto", :opcion2 => "paquete"}, opcion3, Reporte::REDUCIDO)
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_h", :object => @datos, 
	  						:locals => {:escenario => opcion2}
	  				page.visual_effect :appear, "cambiante"
	  			end
	  		when opcion3
	  			@datos = proc_ext(MetaLlamada::tipos_llamadas_nombre, res, Llamada,
		 			{:opcion1 => "tipo_de_llamada", :opcion2 => "producto"}, opcion3, Reporte::REDUCIDO, "Telefonía")
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_h", :object => @datos, 
	  						:locals => {:escenario => opcion3}
	  				page.visual_effect :appear, "cambiante"
	  			end
	  		when opcion4
	  			@datos = proc_ext(MetaLlamada::tipos_llamadas_nombre, res, Llamada,
		 			{:opcion1 => "tipo_de_llamada", :opcion2 => "producto"}, opcion4, Reporte::REDUCIDO, "Televisión")
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_h", :object => @datos, 
	  						:locals => {:escenario => opcion4}
	  				page.visual_effect :appear, "cambiante"
	  			end
	  		when opcion5
	  			@datos = proc_ext(MetaLlamada::tipos_llamadas_nombre, res, Llamada,
		 			{:opcion1 => "tipo_de_llamada", :opcion2 => "producto"}, opcion5, Reporte::REDUCIDO, "Internet")
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_h", :object => @datos, 
	  						:locals => {:escenario => opcion5}
	  				page.visual_effect :appear, "cambiante"
	  			end
	  		when opcion6
	  			titulo = "No Clasificable"
	  			@datos = proc_ind(MetaLlamada::configuraciones_no_clasificable, res, NoClasificable,
		 			{:opcion1 => "tipo_de_llamada", :opcion2 => "concepto_de_la_llamada"}, titulo,
		 			 Reporte::REDUCIDO)
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_h", :object => @datos, 
	  						:locals => {:escenario => opcion6}
	  				page.visual_effect :appear, "cambiante"
	  			end
	  		when opcion7
	  			@datos = proc_esp(Proceso::todos_nombre, opcion7 , res, Llamada,
		 			{:opcion1 => "orden"}, opcion7, Reporte::EXTENDIDO)
		 			session[:actual_datos] = @datos
		 			render :update do |page|
	  				page["cambiante"].replace_html :partial => "resultados_tabla_v", :object => @datos, 
	  						:locals => {:escenario => opcion7}
	  				page.visual_effect :appear, "cambiante"
	  			end
		 end
	end
	
	#Método que se encarga de procesar los datos de reporte de una llamada en sus cuatro tipos, queda excluida
	#de éste método los datos de reporte generales
	def procesa_llamada(listado, res, tipo_llamada, opciones, titulo, producto)
		unless producto.nil?
			if listado.length > 12
				@datos = proc_gen(listado, res, tipo_llamada.constantize, opciones, titulo, Reporte::EXTENDIDO)
				estilo_html = "resultados_tabla_v"
			else
				@datos = proc_gen(listado, res, tipo_llamada.constantize, opciones, titulo, Reporte::REDUCIDO)
				estilo_html = "resultados_tabla_h"
			end 
		else
			if listado.length > 12 
				@datos = proc_esp(listado,titulo, res, tipo_llamada.constantize, opciones, titulo, Reporte::EXTENDIDO)
				estilo_html = "resultados_tabla_v"
			else
				@datos = proc_esp(listado,titulo, res, tipo_llamada.constantize, opciones, titulo, Reporte::REDUCIDO)
				estilo_html = "resultados_tabla_h"
			end 
		end
		session[:actual_datos] = @datos
		render :update do |page|
			page["cambiante"].replace_html :partial => estilo_html, :object => @datos, 
			:locals => {:escenario => titulo}
		  page.visual_effect :appear, "cambiante"
		end  		
	end
	
	def proc_ind(lista, rango, modelo, opciones, titulo, estilo)
		reporte_tabla = Reporte.new(titulo, estilo)
		total_conteo = 0
		if rango[:inicio].nil? or rango[:final].nil?
		  renglon = RenglonReporte.new('Total', modelo.count)
			for elemento in lista
				total_col = modelo.count(:all, :conditions => "#{opciones[:opcion1]} = '#{titulo}' and #{opciones[:opcion2]} = '#{elemento}'")
				total_conteo += total_col
				renglon.agrega_columna(elemento, total_col)	
			end
			renglon.genera_columna_total
			reporte_tabla.agrega_renglon(renglon)
		else
		  renglon = RenglonReporte.new('Total',modelo.count)
			for elemento in lista
				total_col = modelo.count(:all, :conditions => "#{opciones[:opcion1]} = '#{elemento}' and fecha_y_hora BETWEEN '#{rango[:inicio]}' and '#{rango[:final]}'")
				total_conteo += total_col
				renglon.agrega_columna(elemento, total_col)	
			end
			renglon.genera_columna_total
			reporte_tabla.agrega_renglon(renglon)
		end
		reporte_tabla.numero=total_conteo
		datos = reporte_tabla.renglon_a_grafica
		reporte_grafica(titulo.upcase, datos)
		reporte_tabla
	end
		
	#Metodo que calcula la cantidad de ejemplares que cumplen cuatro atributos cómo mínimo, o bien cinco, si
	#se especifíca en la selección un rango de fecha
	def proc_gen(lista, rango, modelo, opciones, titulo, estilo)
			reporte_tabla = Reporte.new(titulo, estilo)
			total_conteo = 0
			@lista = lista
			if rango[:inicio].nil? or rango[:final].nil?
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]} = '#{opciones[:opcion2]}'")
					total_conteo += total_estado
					renglon = RenglonReporte.new(estado,total_estado)
					for elemento in @lista
						total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{opciones[:opcion2]}' and #{opciones[:opcion3]} = '#{elemento}'")
						renglon.agrega_columna(elemento, total_col)					
					end
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			else
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]} = '#{opciones[:opcion2]}' and fecha_y_hora BETWEEN '#{rango[:inicio]}' and '#{rango[:final]}'")
					renglon = RenglonReporte.new(estado,total_estado)
					total_conteo += total_estado
					for elemento in @lista
						total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{opciones[:opcion2]}' and #{opciones[:opcion3]} = '#{elemento}' and fecha_y_hora BETWEEN '#{rango[:inicio]}' and '#{rango[:final]}'")
						renglon.agrega_columna(elemento, total_col)					
					end
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			end	
			reporte_tabla.numero=total_conteo
			datos = reporte_tabla.renglon_a_grafica
			reporte_grafica(titulo.upcase, datos)
			reporte_tabla
	end
	
	def cambia_forma
		tipo = params[:id]
		render :update do |page|
			page['movible'].replace_html :partial => "form_" + tipo
		end
	end
	
	#Metodo que calcula la cantidad de ejemplares que cumplen dos atributos cómo mínimo, o bien tres, si
	#se especifíca en la selección un rango de fecha
	def proc_esp(lista, opcion, rango, modelo, opciones, titulo, estilo)
			reporte_tabla = Reporte.new(titulo, estilo)
			total_conteo = 0
			@lista = lista
			if rango[:inicio].nil? or rango[:final].nil?
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}'")
					total_conteo += total_estado
					renglon = RenglonReporte.new(estado,total_estado)
					for elemento in @lista
						total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{elemento}'")
						renglon.agrega_columna(elemento, total_col)					
					end
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			else
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}' and fecha_y_hora BETWEEN '#{rango[:inicio]}' and '#{rango[:final]}'")
					renglon = RenglonReporte.new(estado,total_estado)
					total_conteo += total_estado
					for elemento in @lista
						total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{elemento}' and fecha_y_hora BETWEEN '#{rango[:inicio]}' and '#{rango[:final]}'")
						renglon.agrega_columna(elemento, total_col)					
					end
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			end	
			reporte_tabla.numero=total_conteo
			datos = reporte_tabla.renglon_a_grafica
			reporte_grafica(opcion.upcase, datos)
			reporte_tabla
	end
	
	def motivos_detalle_en_television(lista, rango, modelo, opciones, titulo, estilo)
			reporte_tabla = Reporte.new(titulo, estilo)
			total_conteo = 0
			if rango[:inicio].nil? or rango[:final].nil?
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}'")
					renglon = RenglonReporte.new(estado,total_estado)
					for elemento in lista
						if elemento == 'Televisión'
							for paquete in Prospecto.paquetes_video
								total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{elemento}' and #{opciones[:opcion2]} = '#{paquete}'")
								renglon.agrega_columna("#{paquete}", total_col)
								total_conteo += total_col
							end
						else
							total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{elemento}'")
							renglon.agrega_columna("#{elemento}", total_col)
							total_conteo += total_col
						end					
					end
					total_col2 = modelo.count(:all, 
					:conditions => "estado = '#{estado}' and tipo_de_llamada = 'Otra'")
					renglon.agrega_columna("Otra", total_col2)
					total_conteo += total_col2
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			else
			end
			reporte_tabla.numero=total_conteo
			datos = reporte_tabla.renglon_a_grafica
			reporte_grafica(titulo.upcase, datos)
			reporte_tabla
	end
	
	def proc_ext(lista, rango, modelo, opciones, titulo, estilo, sub_param)
			reporte_tabla = Reporte.new(titulo, estilo)
			total_conteo = 0
			@lista = lista
			if rango[:inicio].nil? or rango[:final].nil?
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}'")
					renglon = RenglonReporte.new(estado,total_estado)
					for elemento in @lista
						total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{elemento}' and #{opciones[:opcion2]} = '#{sub_param}'")
						renglon.agrega_columna("#{elemento}:#{sub_param}", total_col)
						total_conteo += total_col					
					end
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			else
				for estado in Estado.estados
					total_estado = modelo.count(:all, :conditions => "estado = '#{estado}'")
					renglon = RenglonReporte.new(estado,total_estado)
					for elemento in @lista
						total_col = modelo.count(:all, :conditions => "estado = '#{estado}' and #{opciones[:opcion1]}= '#{elemento}' and #{opciones[:opcion2]} = '#{sub_param}' and fecha_y_hora BETWEEN '#{rango[:inicio]}' and '#{rango[:final]}'")
						renglon.agrega_columna("#{elemento}:#{sub_param}", total_col)
						total_conteo += total_col					
					end
					renglon.genera_columna_total
					reporte_tabla.agrega_renglon(renglon)
				end
			end
			reporte_tabla.numero=total_conteo
			datos = reporte_tabla.renglon_a_grafica
			reporte_grafica(titulo.upcase, datos)
			reporte_tabla
	end
	
	def pdf_reducido(info, p)
	   @estados = info.estados
		 @columnas = info.columnas.clone
		 @renglones = info.renglones
 		 info.genera_renglon_total
		 @total = info.total
		 
		 table = PDF::SimpleTable.new
		 table.title = "Tabla 1"
		 @columnas.insert 0, "Estados"
		 @columnas << "Total"
		 table.column_order = @columnas
		 table.columns["Estados"] = PDF::SimpleTable::Column.new("Estados")
		 table.columns["Estados"].heading = "Estados"
   	 hash_final_t,hash_final_p = Hash.new, Hash.new
		 for col in @columnas
		 	 table.columns[col] = PDF::SimpleTable::Column.new(col)
		 	 table.columns[col].heading = col
		 end
		 table.columns["Total"] = PDF::SimpleTable::Column.new("Total")
		 table.columns["Total"].heading = "Total"

		 table.show_lines    = :all
		 table.show_headings = true
		 table.orientation   = :center
		 table.position      = :center
			
		 arreglo_datos = Array.new	
		 for renglon in @renglones
		 	  hash_total, hash_promedio = Hash.new, Hash.new
		 	  hash_total["Estados"] = to_iso(renglon.estado)
		 		for col in renglon.columnas.keys
		 			hash_total[col] = renglon.columnas[col][:total]
		 		end
		 		hash_promedio[""] = "---"
		 		for col in renglon.columnas.keys
		 			hash_promedio[col] = renglon.columnas[col][:promedio].to_s + "%"
		 		end
		 		arreglo_datos << hash_total
		 		arreglo_datos << hash_promedio
		 end
  	 for c in info.columnas
  	 	 hash_final_t[c] = @total[c][:total]
  	 	 hash_final_p[c] = @total[c][:promedio].to_s + "%"
  	 end
		 hash_final_t["Estados"] = "Totales"
		 hash_final_t["Total"] = @total["Total"][:total]
		 hash_final_p["Total"] = @total["Total"][:promedio].to_s + "%"
 		 arreglo_datos << hash_final_t
 		 arreglo_datos << hash_final_p
		 table.data.replace arreglo_datos
		 table.render_on(p)
		 return p
	end
	
	
	def pdf_extenso(info, p)
	   @estados = info.estados.clone
		 @columnas = info.columnas.clone
		 @renglones = info.renglones
 		 info.genera_renglon_total
		 @total = info.total
		 table = PDF::SimpleTable.new
		 table.font_size = 10
		 table.heading_font_size = 13
		 table.title = "Tabla 1"
		 @estados.insert 0, " "
 		 table.column_order = @estados << "Total"

		 table.columns[" "] = PDF::SimpleTable::Column.new(" ")
		 table.columns[" "].heading = " "
   	 hash_final_t,hash_final_p = Hash.new, Hash.new
		 for estado in @estados
		 	 table.columns[estado] = PDF::SimpleTable::Column.new(estado)
		 	 table.columns[estado].heading = estado
		 end
		 table.columns["Total"] = PDF::SimpleTable::Column.new("Total")
		 table.columns["Total"].heading = "Total"

		 table.show_lines    = :all
		 table.show_headings = true
		 table.orientation   = :center
		 table.position      = :center
			
		 arreglo_datos = Array.new	
		 
		 for key in @columnas
		 	 hash_col_de, hash_col_p = Hash.new, Hash.new
		 	 hash_col_de[" "] = to_iso(key)
 		 	 hash_col_p[" "] = "---"
 		 	 for estado in info.estados
			 		renglon = info.busca_estado(estado) 
			 		hash_col_de[estado] = renglon.columnas[key][:total]
			 		hash_col_p[estado] = renglon.columnas[key][:promedio].to_s + "%" 
			 		hash_col_de["Total"] = @total[key][:total]
			 		hash_col_p["Total"] =  @total[key][:promedio].to_s + "%" 
			 end
 			 arreglo_datos << hash_col_de
 			 arreglo_datos << hash_col_p
		 end
			 hash_final_t[" "] = "Total General"
			 hash_final_p[" "] = " "
  	 for e in info.estados
  	 	 r = info.busca_estado(e)
  	 	 hash_final_t[e] = r.columnas["Total"][:total]
  	 	 hash_final_p[e] = r.columnas["Total"][:promedio].to_s + "%"
  	 end
  	 hash_final_t["Total"] = @total["Total"][:total]
 	 	 hash_final_p["Total"] = @total["Total"][:promedio].to_s + "%"
 		 arreglo_datos << hash_final_t
 		 arreglo_datos << hash_final_p
		 table.data.replace arreglo_datos
		 table.render_on(p)
		 return p
	end
	
	def imagen_muestra_esconde
		if params[:id] == 'a'
			render :update do |page|
				page["imagen"].replace_html :partial => "imagen"
				page.visual_effect :appear, "imagen"
			end
		else
			render :update do |page|
				page.visual_effect :fade, "imagen"
			end
		end
	end
	
	def cambiar_controles
		case params[:rango]
			when "Todos"
				render :update do |page|
					page.visual_effect :fade, "extraccion"
				end
			when "Rango de Tiempo"
				render :update do |page|
					page["extraccion"].replace_html :partial => "controles", :locals => {:opcion => 'a'}
					page.visual_effect :appear, "extraccion"
				end
			when "Acumulados de Hoy"
				render :update do |page|
					page["extraccion"].replace_html :partial => "controles", :locals => {:opcion => 'b'}
					page.visual_effect :appear, "extraccion"
				end
		end
	end
	
	def esconde_prospecto_producto
		render :update do |page|
			if params[:aspecto].eql? 'Cablepaquetes'
				page["producto"].visual_effect :fade
			else 
				page["producto"].visual_effect :appear
			end
		end
	end
	
end
