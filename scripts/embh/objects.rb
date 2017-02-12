=begin

	objects.rb

	Arquivo com as classes usadas para representar coisas no jogo

=end

#==============================================================================
# GameObject
#------------------------------------------------------------------------------
# Classe geral para os objetos do jogo
#==============================================================================
class GameObject < BoundingBox

	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize l, b, r, t, angle = 0.0
		super
		$world.add self
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
		super
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
		super
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
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_STREAM_DRAW
	end
end
#==============================================================================
# Shooter
#------------------------------------------------------------------------------
# Classe geral para os atiradores do jogo (jogador e inimigos)
#==============================================================================
class Shooter < GameObject
	attr_reader :health
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize health, *args
		super *args
		
		@health = [max_health, health].min
		
		@life_meter = LifeMeter.new self
		
		@hit_timer = Timer.new(LIFE_METER_FADE_TIME) do
			@life_meter.hide
			@hit_timer.stop
		end
	end
	#--------------------------------------------------------------------------
	# Atira um projétil
	#--------------------------------------------------------------------------
	def shoot type, *args
		type.new self, *args
	end
	#--------------------------------------------------------------------------
	# Aplica dano ao atirador
	#--------------------------------------------------------------------------
	def damage n = 1	
		@health -= n
		died if dead?

		show_life_meter
	end
	#--------------------------------------------------------------------------
	# Recupera saúde do atirador
	#--------------------------------------------------------------------------
	def heal n = 1
		return if @health >= max_health
		@health = [max_health, @health + n].min
		show_life_meter
	end
	#--------------------------------------------------------------------------
	# Mostra a barra de vida do atirador
	#--------------------------------------------------------------------------
	def show_life_meter
		@life_meter.show
		
		@hit_timer.start
		@hit_timer.reset
	end
	#--------------------------------------------------------------------------
	# Valor máximo para a vida do atirador
	#--------------------------------------------------------------------------
	def max_health
		return Float::INFINITY
	end
	#--------------------------------------------------------------------------
	# Verifica se o atirador morreu
	#--------------------------------------------------------------------------
	def dead?
		return @health <= 0
	end
	#--------------------------------------------------------------------------
	# Evento de morte do atirador
	#--------------------------------------------------------------------------
	def died
		@life_meter.hide
		@hit_timer.stop
	
		dispose
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
	#--------------------------------------------------------------------------
	# Evento de colisão com outro objeto
	#--------------------------------------------------------------------------
	def collision other
		self.damage
		other.dispose
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

	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize		
		super(
			INITIAL_LIFES,
			
			-WIDTH / 2, -0.5 - HEIGHT / 2, 
			WIDTH / 2, -0.5 + HEIGHT / 2
		)
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
			self.damage
			other.dispose
		elsif other.is_a? Enemy
			self.damage
		elsif other.is_a? Bonus
			other.apply! self
			other.dispose
		end
	end
	#--------------------------------------------------------------------------
	# Atira um projétil
	#--------------------------------------------------------------------------
	def shoot
		super StraightBullet, Math::PI / 2
	end
	#--------------------------------------------------------------------------
	# Valor máximo para a vida do atirador
	#--------------------------------------------------------------------------
	def max_health
		return MAX_LIFES
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
		
		shoot if should_shoot?
	end
	#--------------------------------------------------------------------------
	# Verifica se o jogador deveria atirar neste frame
	#--------------------------------------------------------------------------
	def should_shoot?
		return action? && Graphics.frame_count % PLAYER_SHOOT_COOLDOWN == 0
	end
	#--------------------------------------------------------------------------
	# Verifica se os botões de ação estão pressionados
	#--------------------------------------------------------------------------
	def action?
		return Input.press?(:Z) || Input.press?(:SPACE) || Input.press?(:ENTER)
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

	WIDTH = 1.0 / 24.0
	HEIGHT = 1.0 / 24.0

	DROP_FALL_SPEED = Vec2.new(0, 1.0 / 72.0)
	ACCELERATION = Vec2.new(0, -1.0 / 1440.0)

	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize *p, dropped

		if p.size == 2
			position = Vec2.new *p
		elsif p.size == 1
			position = p[0]
		else
			raise ArgumentError.new
		end

		l = position.x - WIDTH / 2
		b = position.y - HEIGHT / 2
		r = position.x + WIDTH / 2
		t = position.y + HEIGHT / 2

		super(l, b, r, t)

		if dropped
			self.velocity = DROP_FALL_SPEED

			@acceleration_timer = Timer.new(1) do
				self.velocity += ACCELERATION
			end
			@acceleration_timer.start
		end
	end
	#--------------------------------------------------------------------------
	# Aplica o bônus a um atirador
	#--------------------------------------------------------------------------
	def apply! shooter
	end
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_STREAM_DRAW
	end
	#--------------------------------------------------------------------------
	# Libera o objeto da memória
	#--------------------------------------------------------------------------
	def dispose
		@acceleration_timer.stop unless @acceleration_timer.nil?

		super
	end
end