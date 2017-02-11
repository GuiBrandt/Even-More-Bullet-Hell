=begin

	objects.rb

	Arquivo com as classes usadas para representar coisas no jogo

=end

#==============================================================================
# GameObject
#------------------------------------------------------------------------------
# Classe geral para os objetos do jogo
#==============================================================================
class GameObject < Drawable
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
		
		$world.add self
	end
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_DYNAMIC_DRAW
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
	def has_point? *p
		if p.size == 2
			p = Vec2.new *p
		else
			p = p[0]
		end
		
		a, b, c, d = *corners
		
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
		vxs = corners
		a, b, c, d = *vxs
	
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
		
		@health = health
		
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
		@life_meter.show
		
		@hit_timer.start
		@hit_timer.reset
	
		@health -= n
		died if dead?
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
			other.apply!
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
	#--------------------------------------------------------------------------
	# Aplica o bônus
	#--------------------------------------------------------------------------
	def apply!
	end
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def init_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_STREAM_DRAW
	end
end