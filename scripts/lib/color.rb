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
	# Transforma a cor num array
	#--------------------------------------------------------------------------
	def to_3f; return [red, green, blue].map {|i| i / 255.0}; end
	def to_4f; return [red, green, blue, alpha].map {|i| i / 255.0}; end
	def to_3b; return [red, green, blue]; end
	def to_4b; return [red, green, blue, alpha]; end
end