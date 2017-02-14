=begin

	stage.rb

	Arquivo para a classe usada para controle dos estágios do jogo

=end

#==============================================================================
# Stage
#------------------------------------------------------------------------------
# Classe geral para o estágios do jogo
#==============================================================================
class Stage
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize
		setup
	end
	#--------------------------------------------------------------------------
	# Inicializa o estágio
	#--------------------------------------------------------------------------
	def setup
	end
	#--------------------------------------------------------------------------
	# Finaliza o estágio
	#--------------------------------------------------------------------------
	def terminate
	end
	#--------------------------------------------------------------------------
	# Verifica se o estágio terminou de limpar a sujeira que fez
	#--------------------------------------------------------------------------
	def done_terminating?
	end
	#--------------------------------------------------------------------------
	# Chama um estágio
	#--------------------------------------------------------------------------
	def self.call klass, *args
		$stage.terminate unless $stage.nil?
		
		Trigger.new(->() { $stage.done_terminating? }) do
			$stage = klass.new *args
		end
	end
	#--------------------------------------------------------------------------
	# Inicia o jogo
	#--------------------------------------------------------------------------
	def start_game
		Stage.call FIRST_STAGE
	end
end