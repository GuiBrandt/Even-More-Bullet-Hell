=begin

  world.rb

  Classe usada para representar o espaço do jogo onde acontecem as interações
  entre os objetos

=end

#==============================================================================
# World
#------------------------------------------------------------------------------
# Classe usada para representar o espaço onde os objetos do jogo estão
#==============================================================================
class World
	SIZE = :TOO_SMALL_FOR_BOTH_OF_US
	
	attr_reader :shader_program, :objects, :enemy_bullets
	
	private :objects, :enemy_bullets
	
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize
		@objects = []
		@drawables = []
		@enemy_bullets = []
		
		@timers = []
		
		@shader_program = ShaderProgram.new
		@shader_program.add_vertex_shader 'basic_2d'
		@shader_program.add_fragment_shader 'basic_rgba'
		@shader_program.link
	end
	#--------------------------------------------------------------------------
	# Adiciona um objeto ao mundo
	#--------------------------------------------------------------------------
	def add object
		if object.is_a?(Bullet) && object.shooter.is_a?(Enemy)
			@enemy_bullets << object
		elsif object.is_a?(GameObject)
			@objects << object
		else
			@drawables << object
		end
	end
	#--------------------------------------------------------------------------
	# Remove um objeto do mundo
	#--------------------------------------------------------------------------
	def remove object
		if object.is_a?(Bullet) && object.shooter.is_a?(Enemy)
			@enemy_bullets.delete object
		elsif object.is_a?(GameObject)
			@objects.delete object
		else
			@drawables.delete object
		end
	end
	#--------------------------------------------------------------------------
	# Adiciona um timer
	#--------------------------------------------------------------------------
	def add_timer timer
		@timers << timer
	end
	#--------------------------------------------------------------------------
	# Remove um timer
	#--------------------------------------------------------------------------
	def remove_timer timer
		@timers.delete timer
	end
	#--------------------------------------------------------------------------
	# Atualização dos objetos
	#--------------------------------------------------------------------------
	def update		
		all_objects.each do |obj|
			obj.position += obj.velocity
			
			unless obj.position.x.between?(-1, 1) && 
					obj.position.y.between?(-1, 1)
				
				obj.out_of_screen
			end
		end
		
		objects.each do |obj|
			@objects.each do |obj2|
				next unless obj.collidable?(obj2)
				obj.collision(obj2) if obj.intersects? obj2
			end
		end
		
		enemy_bullets.each do |obj|
			$player.collision(obj) if obj.intersects? $player
		end
		
		@timers.each do |timer|
			timer.step
		end
		
		if Graphics.skip_frame?
			Graphics.frame_skip
			self.update
		end
	end
	#--------------------------------------------------------------------------
	# Obtém a lista de todos os objetos do jogo
	#--------------------------------------------------------------------------
	def all_objects
		return @enemy_bullets + @objects
	end
	#--------------------------------------------------------------------------
	# Obtém a lista de objetos desenháveis
	#--------------------------------------------------------------------------
	def drawable_objects
		return @objects + @enemy_bullets + @drawables
	end
	#--------------------------------------------------------------------------
	# Desenha os objetos
	#--------------------------------------------------------------------------
	def draw
		@shader_program.use
	
		drawable_objects.each do |obj|
			obj.draw
		end
	end
end