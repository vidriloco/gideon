require 'rubygems'
require 'gruff'

class Grafica

	def configura(object)
		g = Gruff::Pie.new('580x210')
		g.theme = {
       :colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
       :marker_color => '#aaa',
       :background_colors => ['#eaeaea', '#fff']
     }
		g.title = object[:nombre] 
		
		g.data("Apples", [1, 2, 3, 4, 4, 3])
		g.data("Oranges", [4, 8, 7, 9, 8, 9])
		g.data("Watermelon", [2, 3, 1, 5, 6, 8])
		g.data("Peaches", [9, 9, 10, 8, 7, 9])
		g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}
		g.write("images/grafica.png")
	end
end
