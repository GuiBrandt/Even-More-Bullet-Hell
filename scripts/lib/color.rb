=begin

	color.rb

	Arquivo com mudanças na classe color para uso com as funções do OpenGL

=end

#==============================================================================
# Color
#------------------------------------------------------------------------------
# Classe usada para representar uma cor RGB
#==============================================================================
class Color
	#--------------------------------------------------------------------------
	# Obtém uma cor RGB a partir de hsv
	#--------------------------------------------------------------------------
	def self.from_hsv h, s, v
		return Color.new(v * 255, v * 255, v * 255) if s <= 0.0

	    hh = h
	    hh = 0 if hh >= 360
	    hh /= 60.0

	    i = hh.to_i
	    ff = hh - i
	    p = v * (1.0 - s)
	    q = v * (1.0 - (s * ff))
	    t = v * (1.0 - (s * (1.0 - ff)))

	    case i
		    when 0
		        r = v
		        g = t
		        b = p
		    when 1
		    	r = q
		    	g = v
		    	b = p
		    when 2
		        r = p
		        g = v
		        b = t
		    when 3
		        r = p
		        g = q
		        b = v
		    when 4
		        r = t
		        g = p
		        b = v
		    else
		        r = v
		        g = p
		        b = q
		end

	    return Color.new(r * 255, g * 255, b * 255)
	end
	#--------------------------------------------------------------------------
	# Transforma a cor num array
	#--------------------------------------------------------------------------
	def to_3f; return [red, green, blue].map {|i| i / 255.0}; end
	def to_4f; return [red, green, blue, alpha].map {|i| i / 255.0}; end
	def to_3b; return [red, green, blue]; end
	def to_4b; return [red, green, blue, alpha]; end
	#--------------------------------------------------------------------------
	# Obtém a cor inversa a esta
	#--------------------------------------------------------------------------
	def inverse
		return Color.new(
			255 - self.red, 
			255 - self.green, 
			255 - self.blue, 
			self.alpha
		)
	end
end