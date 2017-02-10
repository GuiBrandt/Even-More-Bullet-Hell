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
	
	attr_reader :shader_program
	
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize
		@objects = []
		
		@shader_program = ShaderProgram.new
		@shader_program.add_vertex_shader 'basic_2d'
		@shader_program.add_fragment_shader 'basic_rgba'
		@shader_program.link
	end
	#--------------------------------------------------------------------------
	# Adiciona um objeto ao mundo
	#--------------------------------------------------------------------------
	def add object
		@objects << object
	end
	#--------------------------------------------------------------------------
	# Remove um objeto do mundo
	#--------------------------------------------------------------------------
	def remove object
		@objects.delete object
	end
	#--------------------------------------------------------------------------
	# Atualização dos objetos
	#--------------------------------------------------------------------------
	def update		
		each_object do |obj|
			obj.position += obj.velocity
			
			unless obj.position.x.between?(-1, 1) && 
					obj.position.y.between?(-1, 1)
				
				obj.out_of_screen
			end
		end
		
		each_object do |obj|
			each_object do |obj2|
				next unless obj.collidable?(obj2)
				obj.collision(obj2) if obj.intersects? obj2
			end
		end
	end
	#--------------------------------------------------------------------------
	# Executa um bloco para cada objeto no mundo
	#--------------------------------------------------------------------------
	def each_object
		@objects.each_with_index do |obj|
			yield obj
		end
	end
	#--------------------------------------------------------------------------
	# Desenha os objetos
	#--------------------------------------------------------------------------
	def draw
		@shader_program.use
	
		each_object do |obj|
			obj.draw
		end
	end
end