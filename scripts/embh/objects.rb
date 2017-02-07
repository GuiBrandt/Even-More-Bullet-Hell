=begin

	objects.rb

	Arquivo com as classes usadas para representar coisas no jogo

=end

#==============================================================================
# AbstractHitbox
#------------------------------------------------------------------------------
# Classe abstrata usada para representar as caixas de colisão dos objetos 
# do jogo
#==============================================================================
class AbstractHitbox
	attr_accessor :x, :y
	#--------------------------------------------------------------------------
	# Construtor
	#
	# => x		: Posição X da hitbox
	# => y 		: Posição Y da hitbox
	#--------------------------------------------------------------------------
	def initialize x, y
		@x = x
		@y = y
	end
	#--------------------------------------------------------------------------
	# Verifica colisão com outra hitbox
	#--------------------------------------------------------------------------
	def collides? other_hitbox
		return false
	end
	#--------------------------------------------------------------------------
	# Verifica se um ponto está dentro da hitbox
	# => x 		: Posição X do ponto
	# => y 		: Posição Y do ponto
	#--------------------------------------------------------------------------
	def contains_point? x, y
		return false
	end
	#--------------------------------------------------------------------------
	# Verifica se a hitbox intercepta uma linha de A a B
	#
	# => ax 	: Posição X do ponto A
	# => ay 	: Posição Y do ponto A
	# => bx 	: Posição X do ponto B
	# => by 	: Posição Y do ponto B
	#--------------------------------------------------------------------------
	def intersects_line? ax, ay, bx, by
		return false
	end
	#--------------------------------------------------------------------------
	# Obtém um array com os vértices da hitbox
	#--------------------------------------------------------------------------
	def vertices
		return []
	end
end
#==============================================================================
# RectHitbox
#------------------------------------------------------------------------------
# Classe usada para representar hitboxes retangulares
#==============================================================================
class RectHitbox < AbstractHitbox
	attr_reader :width, :height
	#--------------------------------------------------------------------------
	# Construtor
	#
	# => x		: Posição X da hitbox
	# => y 		: Posição Y da hitbox
	# => w 		: Largura da hitbox
	# => h 		: Altura da hitbox
	#--------------------------------------------------------------------------
	def initialize x, y, w, h
		super x, y

		@width = w
		@height = h
	end
	#--------------------------------------------------------------------------
	# Verifica colisão com outra hitbox
	#--------------------------------------------------------------------------
	def collides? other_hitbox

		if other_hitbox.is_a? CircleHitbox
			return other_hitbox.collides? self

		elsif other_hitbox.is_a? RectHitbox

			a = other_hitbox.left
			b = other_hitbox.right
			c = other_hitbox.top
			d = other_hitbox.bottom

			return contains_point?(a, c) || contains_point?(a, d) || 
				   contains_point?(b, c) || contains_point(b, d)  ||
				   other_hitbox.contains_point?(left, top) 		  ||
				   other_hitbox.contains_point?(left, bottom)	  ||
				   other_hitbox.contains_point?(left, top) 		  ||
				   other_hitbox.contains_point?(right, bottom)
		end

		return false
	end
	#--------------------------------------------------------------------------
	# Verifica se um ponto está dentro da hitbox
	# => x 		: Posição X do ponto
	# => y 		: Posição Y do ponto
	#--------------------------------------------------------------------------
	def contains_point? x, y
		return x.between?(left, right) && y.between?(top, bottom)
	end
	#--------------------------------------------------------------------------
	# Verifica se a hitbox intercepta uma linha de A a B
	#
	# => ax 	: Posição X do ponto A
	# => ay 	: Posição Y do ponto A
	# => bx 	: Posição X do ponto B
	# => by 	: Posição Y do ponto B
	#--------------------------------------------------------------------------
	def intersects_line? ax, ay, bx, by
		
		line_intersects_line = ->(
			x1, y1, 
			x2, y2,

			x3, y3, 
			x4, y4) do
			
			a1 = y2 - y1
			b1 = x1 - x2
			c1 = x2 * y1 - x1 * x2

			r3 = a1 * x3 + b1 * y3 + c1
			r4 = a1 * x4 + b1 * y4 + c1

			if r3 != 0 && r4 != 0 && r3 / r3.abs == r4 / r4.abs
				return false
			end

			a2 = y4 - y3
			b2 = x3 - x4
			c2 = x4 * y3 - x4 * y4

			r1 = a2 * x1 + b2 * y1 + c2;
    		r2 = a2 * x2 + b2 * y2 + c2

			if r1 != 0 && r2 != 0 && r1 / r1.abs == r2 / r2.abs
				return false
			end

			return true
		end

		return 	line_intersects_line(left, top, right, top, ax, ay, bx, by) 	  || 
			   	line_intersects_line(right, top, right, bottom, ax, ay, bx, by)   ||
			   	line_intersects_line(right, bottom, left, bottom, ax, ay, bx, by) ||
			   	line_intersects_line(left, bottom, left, top, ax, ay, bx, by)
	end
	#--------------------------------------------------------------------------
	# Coordenadas a partir dos lados do retângulo
	#--------------------------------------------------------------------------
	def left; 	return x - width / 2; 	end
	def right; 	return x + width / 2; 	end
	def top; 	return y - height / 2; 	end
	def bottom; return y + height / 2; 	end
	#--------------------------------------------------------------------------
	# Obtém o tamanho da diagonal da hitbox
	#--------------------------------------------------------------------------
	def diagonal
		return Math.hypot(width, height)
	end
	#--------------------------------------------------------------------------
	# Obtém um array com os vértices da hitbox
	#--------------------------------------------------------------------------
	def vertices
		ox = width / 2
		oy = height / 2

		return [
			-ox, 		-oy,
			width - ox, -oy,
			-ox, 		height - oy,

			width - ox, -oy,
			width - ox, height - oy,
			-ox, 		height - oy
		]
	end
end
#==============================================================================
# CircleHitbox
#------------------------------------------------------------------------------
# Classe usada para representar hitboxes circulares
#==============================================================================
class CircleHitbox < AbstractHitbox
	attr_reader :radius
	#--------------------------------------------------------------------------
	# Construtor
	#
	# => x		: Posição X da hitbox
	# => y 		: Posição Y da hitbox
	# => radius	: Raio da hitbox
	#--------------------------------------------------------------------------
	def initialize x, y, radius
		super x, y

		@radius = radius
	end
	#--------------------------------------------------------------------------
	# Verifica colisão com outra hitbox
	#--------------------------------------------------------------------------
	def collides? other_hitbox

		if other_hitbox.is_a? CircleHitbox

			dx = x - other_hitbox.x
			dy = y - other_hitbox.y
			distance_sqr = dx * dx + dy * dy

			return distance_sqr <= (radius + other_hitbox.radius) ** 2

		elsif other_hitbox.is_a? RectHitbox
			
			closest_x = [x, other_hitbox.left, other_hitbox.right].sort[1]
			closest_y = [y, other_hitbox.top, other_hitbox.bottom].sort[1]

			dx = x - closest_x
			dy = y - closest_y

			return radius * radius >= dx * dx + dy * dy

		end

		return false
	end
	#--------------------------------------------------------------------------
	# Verifica se um ponto está dentro da hitbox
	# => x 		: Posição X do ponto
	# => y 		: Posição Y do ponto
	#--------------------------------------------------------------------------
	def contains_point? x, y
		dx = self.x - x
		dy = self.y - y
		return dx * dx + dy * dy < radius * radius
	end
	#--------------------------------------------------------------------------
	# Número de vértices da hitbox
	#--------------------------------------------------------------------------
	def vertex_count
		return [4, @radius / 3].max.floor
	end
	#--------------------------------------------------------------------------
	# Obtém um array com os vértices da hitbox
	#--------------------------------------------------------------------------
	def vertices
		ox = oy = radius / 2

		step = Math::PI * 2 / vertex_count
		return Array.new(vertex_count) do |i|
			theta = step * i
			[Math.cos(theta) * radius - ox, Math.sin(theta) * radius - oy]
		end
	end
end