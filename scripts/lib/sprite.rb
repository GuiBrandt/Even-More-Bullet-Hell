=begin

  sprite.rb

  Reescrita da classe sprite para uso com o OpenGL

=end

#==============================================================================
# Sprite
#------------------------------------------------------------------------------
# Classe das imagens 2D que aparecem na tela
#==============================================================================
class Sprite < Drawable
	attr_accessor :texture, :position
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize img, *p
		if img.is_a? Bitmap
			@texture = Texture.new img
		elsif img.is_a? Texture
			@texture = img
		else
			raise ArgumentError.new
		end

		if p.size == 2
			@position = p[0]
			@size = p[1]
		elsif p.size == 4
			@position = Vec2.new *p[0, 2]
			@size = Vec2.new *p[2, 2]
		else
			raise ArgumentError.new
		end

		super()
	end
	#--------------------------------------------------------------------------
	# Inicializa o buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 4, 6, GL_DYNAMIC_DRAW
	end
	#--------------------------------------------------------------------------
	# Desenha o sprite na tela
	#--------------------------------------------------------------------------
	def draw
		x, y, w, h = @position.x, @position.y, @size.x, @size.y

		l = x - w
		b = y - h
		r = x + w
		t = y + h

		@vertex_buffer.data = [
		# 	X	Y 	U 	V

			l,	t,	0,  0,
			r,	t,	1,	0,
			l,	b,	0,	1,

			r, 	t, 	1,	0,
			r,	b,	1,	1,
			l,	b, 	0,	1
		]

		Graphics.sprite_shader_program.use
		@texture.bind

		glBlendFunc GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
		glDisable GL_POLYGON_SMOOTH

		@vertex_buffer.draw
		glBlendFunc GL_SRC_ALPHA, GL_ONE
		glEnable GL_POLYGON_SMOOTH if ANTIALIASING
	end
	#--------------------------------------------------------------------------
	# Libera o sprite da memória
	#--------------------------------------------------------------------------
	def dispose
		super

		@texture.dispose
	end
end
