=begin

  timer.rb

  Arquivo usado para a classe do Timer, usado para executar um bloco de código
  repetidamente em um intervalo constante de frames

=end

#==============================================================================
# Timer
#------------------------------------------------------------------------------
# Classe usada para criar um timer que executa um bloco de código em um 
# intervalo constante
#==============================================================================
class Timer
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize interval, run_first = false, &block
		@interval = interval
		@block = block
		@run_first = run_first
		
		reset
	end
	#--------------------------------------------------------------------------
	# Reseta o timer
	#--------------------------------------------------------------------------
	def reset
		@tick = 0
	end
	#--------------------------------------------------------------------------
	# Começa o timer
	#--------------------------------------------------------------------------
	def start
		$world.add_timer self
		@block.call if @run_first && @tick.zero?
	end
	#--------------------------------------------------------------------------
	# Para o timer
	#--------------------------------------------------------------------------
	def stop
		$world.remove_timer self
	end
	#--------------------------------------------------------------------------
	# Anda um passo na contagem
	#--------------------------------------------------------------------------
	def step	
		@tick += 1
		
		if @tick == @interval
			@block.call
			reset
		end
	end
end