=begin

	drawable.rb

	Arquivo com a classe usada para representar os objetos que podem ser
	desenhados na tela

=end

#==============================================================================
# Drawable
#------------------------------------------------------------------------------
# Módulo para os objetos desenháveis
#==============================================================================
class Drawable
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize
		init_vertex_buffer
	end
	#--------------------------------------------------------------------------
	# Inicializa o buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = nil
	end
	#--------------------------------------------------------------------------
	# Desenha o objeto na tela
	#--------------------------------------------------------------------------
	def draw
		@vertex_buffer.draw
	end
	#--------------------------------------------------------------------------
	# Libera o objeto da memória
	#--------------------------------------------------------------------------
	def dispose
		@vertex_buffer.dispose unless @vertex_buffer.nil?
	end
end