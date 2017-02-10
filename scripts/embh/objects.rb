=begin

	objects.rb

	Arquivo com as classes usadas para representar coisas no jogo

=end

#==============================================================================
# GameObject
#------------------------------------------------------------------------------
# Classe geral para os objetos do jogo
#==============================================================================
class GameObject
	attr_reader :left, :bottom, :right, :top
	attr_accessor :velocity
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize l, b, r, t
		@left = l
		@bottom = b
		@right = r
		@top = t
		@velocity = Vec2::ZERO
		
		initialize_vertex_buffer
		
		$world.add self
	end
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def initialize_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_STREAM_DRAW
	end
	#--------------------------------------------------------------------------
	# Cor do objeto
	#--------------------------------------------------------------------------
	def color
		return Color.new(0, 0, 0)
	end
	#--------------------------------------------------------------------------
	# Desenha o objeto na tela
	#--------------------------------------------------------------------------
	def draw
		glUniform4f $world.shader_program[:color], *self.color.to_4f
		@vertex_buffer.data = self.vertices
		@vertex_buffer.draw
	end
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def self.new_for_extents x, y, hw, hh
		return Hitbox.new x - hw, y - hh, x + hw, y + hh
	end
	#--------------------------------------------------------------------------
	# Verifica colisão com outra caixa
	#--------------------------------------------------------------------------
	def intersects? other
		return self.left <= other.right &&
			   other.left <= self.right &&
			   self.bottom <= other.top &&
			   other.bottom <= self.top
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
	def vertices
		return [
			@left,  @top,
			@right, @top,
			@left,  @bottom,
			
			@right, @top,
			@right, @bottom,
			@left,  @bottom
		]
	end
	#--------------------------------------------------------------------------
	# Verifica se um objeto pode colidir com outro
	#--------------------------------------------------------------------------
	def collidable? other
		return false
	end
	#--------------------------------------------------------------------------
	# Evento de colisão com outro objeto
	#--------------------------------------------------------------------------
	def collision other
	end
	#--------------------------------------------------------------------------
	# Evento de quando o objeto sai da tela
	#--------------------------------------------------------------------------
	def out_of_screen
		dispose
	end
	#--------------------------------------------------------------------------
	# Apaga o objeto
	#--------------------------------------------------------------------------
	def dispose
		$world.remove self
	end
end
#==============================================================================
# Bullet
#------------------------------------------------------------------------------
# Classe geral para os projéteis do jogo
#==============================================================================
class Bullet < GameObject
	attr_reader :shooter
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize shooter, *args
		@shooter = shooter
		
		super *args
	end
end
#==============================================================================
# Shooter
#------------------------------------------------------------------------------
# Classe geral para os atiradores do jogo (jogador e inimigos)
#==============================================================================
class Shooter < GameObject
	#--------------------------------------------------------------------------
	# Atira um projétil
	#--------------------------------------------------------------------------
	def shoot type, *args
		type.new self, *args
	end
end
#==============================================================================
# Enemy
#------------------------------------------------------------------------------
# Classe geral para os inimigos
#==============================================================================
class Enemy < Shooter
	#--------------------------------------------------------------------------
	# Verifica se um objeto pode colidir com outro
	#--------------------------------------------------------------------------
	def collidable? other
		return other.is_a?(Bullet) && other.shooter.is_a?(Player)
	end
end
#==============================================================================
# Player
#------------------------------------------------------------------------------
# Classe para o jogador
#==============================================================================
class Player < Shooter

	WIDTH = 1.0 / 36.0
	HEIGHT = 1.0 / 36.0

	attr_reader :lifes
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize		
		super(
			-WIDTH / 2, -0.3 - HEIGHT / 2, 
			WIDTH / 2, -0.3 + HEIGHT / 2
		)
		
		@lifes = INITIAL_LIFES
	end
	#--------------------------------------------------------------------------
	# Cor do objeto
	#--------------------------------------------------------------------------
	def color
		return Color.new(0, 255, 0)
	end
	#--------------------------------------------------------------------------
	# Verifica se um objeto pode colidir com outro
	#--------------------------------------------------------------------------
	def collidable? other
		return 	(other.is_a?(Bullet) && other.shooter.is_a?(Enemy)) || 
				other.is_a?(Enemy) || other.is_a?(Bonus)
	end
	#--------------------------------------------------------------------------
	# Evento de colisão com outro objeto
	#--------------------------------------------------------------------------
	def collision other
		if other.is_a? Bullet
			@lifes -= 1
			other.dispose
			
			check_death
		elsif other.is_a? Enemy
			@lifes -= 1
			check_death
		elsif other.is_a? Bonus
			other.apply!
			other.dispose
		end
	end
	#--------------------------------------------------------------------------
	# Verifica se o jogador morreu e executa o procedimento necessário caso
	# tenha
	#--------------------------------------------------------------------------
	def check_death
		Game.game_over if @lifes.zero?
	end
	#--------------------------------------------------------------------------
	# Atira um projétil
	#--------------------------------------------------------------------------
	def shoot
		super StraightBullet, Math::PI / 2
	end
	#--------------------------------------------------------------------------
	# Processa entrada do teclado
	#--------------------------------------------------------------------------
	def process_input
		d = Input.dir8
		
		if d.zero?
			self.stop
		else	
			a = 0
		
			case d
			when 1
				a = -Math::PI * 3 / 4
			when 2
				a = -Math::PI / 2
			when 3
				a = -Math::PI / 4
			when 4
				a = Math::PI
			when 6
				a = 0
			when 7
				a = Math::PI * 3 / 4
			when 8
				a = Math::PI / 2
			when 9
				a = Math::PI / 4
			end
			
			self.velocity = Vec2.for_angle(a)
			
			if Input.press? :SHIFT
				self.velocity *= PLAYER_SPEED
			else
				self.velocity *= PLAYER_FAST_SPEED
			end
		end
		
		if (Input.press?(:Z) || Input.press?(:SPACE)) && 
			Graphics.frame_count % PLAYER_SHOOT_COOLDOWN == 0
			self.shoot
		end
	end
	#--------------------------------------------------------------------------
	# Evento de quando o objeto sai da tela
	#--------------------------------------------------------------------------
	def out_of_screen
		x = position.x.clamp(-1, 1)
		y = position.y.clamp(-1, 1)
		self.position = Vec2.new(x, y)
	end
end
#==============================================================================
# Bonus
#------------------------------------------------------------------------------
# Classe geral para os bônus que aparecem de vez em quando
#==============================================================================
class Bonus < GameObject
	#--------------------------------------------------------------------------
	# Aplica o bônus
	#--------------------------------------------------------------------------
	def apply!
	end
end