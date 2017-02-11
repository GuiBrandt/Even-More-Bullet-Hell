=begin

	box.rb

	Arquivo com a classe usada para representar as hitboxes usadas nas colisões
	do jogo

=end

#==============================================================================
# BoundingBox
#------------------------------------------------------------------------------
# Classe usada para representar uma hitbox rotacionável do jogo
#==============================================================================
class BoundingBox < Drawable
	attr_reader :left, :bottom, :right, :top
	protected :left, :bottom, :right, :top
	
	attr_accessor :velocity, :rotation
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize l, b, r, t, angle = 0.0
		super()
		
		@left = l
		@bottom = b
		@right = r
		@top = t
		@rotation = angle
		@velocity = Vec2::ZERO
	end
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_DYNAMIC_DRAW
	end
	#--------------------------------------------------------------------------
	# Desenha o objeto na tela
	#--------------------------------------------------------------------------
	def draw
		@vertex_buffer.data = self.vertices
		super
	end
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def self.new_for_extents x, y, hw, hh
		return BoundingBox.new x - hw, y - hh, x + hw, y + hh
	end
	#--------------------------------------------------------------------------
	# Verifica colisão com outra caixa
	#--------------------------------------------------------------------------
	def intersects? other
		if self.rotation - other.rotation == 0.0
			return self.left <= other.right &&
				   other.left <= self.right &&
				   self.bottom <= other.top &&
				   other.bottom <= self.top
		else
			return self.near?(other) && 
					(other.corners.any? {|c| self.has_point?(c)} || 
					self.corners.any? {|c| other.has_point?(c)})
		end
	end
	#--------------------------------------------------------------------------
	# Verifica se um ponto está dentro do objeto
	#--------------------------------------------------------------------------
	def has_point? p
		a, b, c, d = *self.corners
		
		ad = a - d
		cd = c - d
		tpc = p * 2 - a - c
		
		return cd.dot(tpc - cd) <= 0 && cd.dot(tpc + cd) >= 0 &&
				ad.dot(tpc - ad) <= 0 && ad.dot(tpc + ad) >= 0
	end
	#--------------------------------------------------------------------------
	# Verifica se a caixa está perto o suficiente de outra para uma colisão
	#--------------------------------------------------------------------------
	def near? other
		w = @right - @left
		h = @top - @bottom
		dsq = w * w + h * h
		
		w = other.right - other.left
		h = other.top - other.bottom
		dsq += w * w + h * h
		
		return self.position.distancesq(other.position) <= dsq / 2
	end
	#--------------------------------------------------------------------------
	# Empura a caixa com uma força vetorial `vect`
	#--------------------------------------------------------------------------
	def impulse vect
		@velocity += vect
	end
	#--------------------------------------------------------------------------
	# Para a caixa
	#--------------------------------------------------------------------------
	def stop
		@velocity = Vec2::ZERO
	end
	#--------------------------------------------------------------------------
	# Posição do centro da hitbox
	#--------------------------------------------------------------------------
	def position
		return Vec2.new((@left + @right) / 2, (@top + @bottom) / 2)
	end
	#--------------------------------------------------------------------------
	# Define a posição do centro da hitbox
	#--------------------------------------------------------------------------
	def position=(vect)
		hw = (@right - @left) / 2
		hh = (@top - @bottom) / 2
		
		@left = vect.x - hw
		@right = vect.x + hw
		@top = vect.y + hh
		@bottom = vect.y - hh
	end
	#--------------------------------------------------------------------------
	# Lista de vértices 2D da caixa
	#--------------------------------------------------------------------------
	def corners
		origin = position
	
		cos = Math.cos(rotation)
		sin = Math.sin(rotation)
	
		ax = origin.x + (@left - origin.x) * cos - (@top - origin.y) * sin
		ay = origin.y + (@left - origin.x) * sin + (@top - origin.y) * cos
		
		bx = origin.x + (@right - origin.x) * cos - (@top - origin.y) * sin
		by = origin.y + (@right - origin.x) * sin + (@top - origin.y) * cos
		
		cx = origin.x + (@right - origin.x) * cos - (@bottom - origin.y) * sin
		cy = origin.y + (@right - origin.x) * sin + (@bottom - origin.y) * cos
		
		dx = origin.x + (@left - origin.x) * cos - (@bottom - origin.y) * sin
		dy = origin.y + (@left - origin.x) * sin + (@bottom - origin.y) * cos
	
		return [
			Vec2.new(ax, ay),
			Vec2.new(bx, by),
			Vec2.new(cx, cy),
			Vec2.new(dx, dy)
		]
	end
	#--------------------------------------------------------------------------
	# Lista de vértices 2D da caixa, usado para desenhos
	#--------------------------------------------------------------------------
	def vertices
		a, b, c, d = *self.corners
	
		return [
			a.x, a.y,
			b.x, b.y,
			c.x, c.y,
			
			c.x, c.y,
			d.x, d.y,
			a.x, a.y
		]
	end
	#--------------------------------------------------------------------------
	# Obtém a largura do objeto
	#--------------------------------------------------------------------------
	def width
		x_coords = corners.map {|c| c.x }
		return x_coords.max - x_coords.min
	end
	#--------------------------------------------------------------------------
	# Obtém a altura do objeto
	#--------------------------------------------------------------------------
	def height
		y_coords = corners.map {|c| c.y }
		return y_coords.max - y_coords.min
	end
end