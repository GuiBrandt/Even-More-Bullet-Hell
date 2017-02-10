=begin

  utils.rb

  Funções e classes legais feitas pra deixar sua vida mais fácil

=end

#==============================================================================
# Numeric
#------------------------------------------------------------------------------
# Classe dos números
#==============================================================================
class Numeric
	#--------------------------------------------------------------------------
	# Limita um número entre outros dois
	#--------------------------------------------------------------------------
	def clamp min, max
		[[self, min].max, max].min
	end
end
#==============================================================================
# Vec2
#------------------------------------------------------------------------------
# Classe usada para representar um vetor bidimensional
#==============================================================================
class Vec2
	attr_reader :x, :y
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize x, y
		@x = x
		@y = y
	end
	#--------------------------------------------------------------------------
	# Verifica igualdade entre vetores
	#--------------------------------------------------------------------------
	def ==(other)
		return false unless other.is_a? Vec2
		return self.x == other.x && self.y == other.y
	end
	#--------------------------------------------------------------------------
	# Soma dois vetores
	#--------------------------------------------------------------------------
	def +(other)
		return Vec2.new(self.x + other.x, self.y + other.y)
	end
	#--------------------------------------------------------------------------
	# Subtrai dois vetores
	#--------------------------------------------------------------------------
	def -(other)
		return Vec2.new(self.x - other.x, self.y - other.y)
	end
	#--------------------------------------------------------------------------
	# Negativa o vetor
	#--------------------------------------------------------------------------
	def -@
		return Vec2.new(-self.x, -self.y)
	end
	#--------------------------------------------------------------------------
	# Multiplica o vetor por um número
	#--------------------------------------------------------------------------
	def *(scale)
		return Vec2.new(self.x * scale, self.y * scale)
	end
	#--------------------------------------------------------------------------
	# Divide o vetor por um número
	#--------------------------------------------------------------------------
	def /(scale)
		return Vec2.new(self.x / scale, self.y / scale)
	end
	#--------------------------------------------------------------------------
	# Produto ponto do vetor
	#--------------------------------------------------------------------------
	def dot(other)
		return self.x * other.x + self.y * other.y
	end
	#--------------------------------------------------------------------------
	# Produto cruz do vetor
	#--------------------------------------------------------------------------
	def cross(other)
		return self.x * other.y - self.y * other.x
	end
	#--------------------------------------------------------------------------
	# Obtém um vetor perpendicular a este
	#--------------------------------------------------------------------------
	def perp
		return Vec2.new(-self.y, self.x)
	end
	#--------------------------------------------------------------------------
	# Obtém um vetor perpendicular a este (na outra direção)
	#--------------------------------------------------------------------------
	def rperp
		return Vec2.new(self.y, -self.x)
	end
	#--------------------------------------------------------------------------
	# Obtém a projeção deste vetor em outro vetor
	#--------------------------------------------------------------------------
	def project(other)
		return other * self.dot(other) / other.dot(other)
	end
	#--------------------------------------------------------------------------
	# Obtém o ângulo do vetor
	#--------------------------------------------------------------------------
	def to_angle
		return Math.atan2(self.y, self.x)
	end
	#--------------------------------------------------------------------------
	# Rotaciona o vetor pelo ângulo especificado
	#--------------------------------------------------------------------------
	def rotate a
		other = Vec2.for_angle a
		
		return Vec2.new(
			self.x * other.x - self.y * other.y,
			self.x * other.y + self.y * other.x
		)
	end
	#--------------------------------------------------------------------------
	# Obtém a largura do vetor ao quadrado (mais rápido que só obter a largura)
	#--------------------------------------------------------------------------
	def lengthsq
		return self.dot(self)
	end
	#--------------------------------------------------------------------------
	# Obtém a largura do vetor
	#--------------------------------------------------------------------------
	def length
		return Math.sqrt(self.lengthsq)
	end
	#--------------------------------------------------------------------------
	# Normaliza o vetor
	#--------------------------------------------------------------------------
	def normalize
		len = self.length
		return Vec2::ZERO if len == 0
		return self / len
	end
	#--------------------------------------------------------------------------
	# Limita o vetor em tamanho
	#--------------------------------------------------------------------------
	def clamp len
		if len.is_a? Numeric
			return self.lengthsq > len*len ? self.normalize * len : self
		else
			return Vec2.new(
				self.x.clamp(len.l, len.r),
				self.y.clamp(len.b, len.t)
			)
		end
	end
	#--------------------------------------------------------------------------
	# Obtém a distância entre este vetor e outro
	#--------------------------------------------------------------------------
	def distance other
		return (self - other).length
	end
	#--------------------------------------------------------------------------
	# Obtém a distância entre este vetor e outro ao quadrado (mais rápido)
	#--------------------------------------------------------------------------
	def distancesq other
		return (self - other).lengthsq
	end
	#--------------------------------------------------------------------------
	# Verifica se este vetor está próximo de outro
	#--------------------------------------------------------------------------
	def near other, dist
		return self.distance(other) < dist*dist
	end
	#--------------------------------------------------------------------------
	# Obtém um vetor para um ângulo
	#--------------------------------------------------------------------------
	def self.for_angle a
		return Vec2.new(Math.cos(a), Math.sin(a))
	end
	#--------------------------------------------------------------------------
	# Constante para o vetor zero
	#--------------------------------------------------------------------------
	ZERO = Vec2.new(0, 0)
end