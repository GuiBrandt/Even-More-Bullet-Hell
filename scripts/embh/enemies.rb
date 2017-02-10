=begin
	
	enemies.rb
	
	Arquivo usado para definição das classes de inimigo do jogo

=end

#==============================================================================
# Enemy1
#------------------------------------------------------------------------------
# Inimigo genérico tipo 1:
#	Atira circulos de projéteis de 1,5 em 1,5 segundos
#==============================================================================
class Enemy1 < Enemy

	WIDTH = 1.0 / 32.0
	HEIGHT = 1.0 / 32.0	

	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize *args
		if args.size == 2
			x, y = *args
		elsif args.size == 1
			x, y = args[0].x, args[0].y
		else
			raise ArgumentError.new
		end
		
		super(
			20,
			
			x - WIDTH / 2, y - HEIGHT / 2,
			x + WIDTH / 2, y + HEIGHT / 2
		)
		
		@timer = Timer.new(90, true) do
			p = 32
			
			for i in 0...p
				a = Math::PI * 2 / 32 * i
				
				self.shoot StraightBullet, a, 1.0 / 144.0
			end
		end
		@timer.start
	end
	#--------------------------------------------------------------------------
	# Inicialização do buffer de vértice do objeto
	#--------------------------------------------------------------------------
	def initialize_vertex_buffer
		@vertex_buffer = VertexBuffer.new 2, 6, GL_STATIC_DRAW
	end
	#--------------------------------------------------------------------------
	# Cor do objeto
	#--------------------------------------------------------------------------
	def color
		return Color.new(255, 0, 0)
	end
	#--------------------------------------------------------------------------
	# Evento de morte do inimigo
	#--------------------------------------------------------------------------
	def died
		Enemy1.new rand(1000) / 1000.0 - 0.5, rand(1000) / 1000.0 - 0.5
		Enemy1.new rand(1000) / 1000.0 - 0.5, rand(1000) / 1000.0 - 0.5
		
		@timer.stop
		
		super
	end
end