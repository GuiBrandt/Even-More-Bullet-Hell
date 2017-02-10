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

	WIDTH  = 0.90
	HEIGHT = 0.01

	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize shooter
		super()
	
		@shooter = shooter
	end
	#--------------------------------------------------------------------------
	# Inicializa o buffer de vértice do medidor
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_DYNAMIC_DRAW
	end
	#--------------------------------------------------------------------------
	# Mostra o medidor na tela
	#--------------------------------------------------------------------------
	def show
		$world.add self
	end
	#--------------------------------------------------------------------------
	# Esconde o medidor da tela
	#--------------------------------------------------------------------------
	def hide
		$world.remove self
	end
	#--------------------------------------------------------------------------
	# Desenha o medidor na tela
	#--------------------------------------------------------------------------
	def draw
		glUniform4f $world.shader_program[:color], *@shooter.color.inverse.to_4f

		if @shooter.is_a?(Player)
			hw = WIDTH / 2 * @shooter.health / (MAX_LIFES + 1)
			hh = HEIGHT / 2
		
			position = Vec2.new(0, -0.9)
		else
			hw = WIDTH / 2 * @shooter.health / 105
			hh = HEIGHT / 2
		
			position = @shooter.position + Vec2.new(0, @shooter.height + HEIGHT)
		end
		
		l = position.x - hw
		b = position.y - hh
		r = position.x + hw
		t = position.y + hh
		
		@vertex_buffer.data = [
			l, t, r, t, r, b,
			r, b, l, b, l, t			
		]
		@vertex_buffer.draw
	end
end