=begin

	life_meter.rb

	Arquivo com as classes usadas para desenhar uma barrinha de vida na tela

=end

#==============================================================================
# LifeMeter
#------------------------------------------------------------------------------
# Medidor de vida de um atirador
#==============================================================================
class LifeMeter < Drawable
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize shooter, *position
		super
	
		@shooter = shooter
		
		if position.size == 2
			@position = Vec2.new *position
		elsif position.size == 1
			@position = position[0]
		else
			raise ArgumentError.new
		end
	end
	#--------------------------------------------------------------------------
	# Inicializa o buffer de vértice do medidor
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = nil
	end
	#--------------------------------------------------------------------------
	# Desenha o medidor na tela
	#--------------------------------------------------------------------------
	def draw
	end
end