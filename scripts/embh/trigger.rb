=begin

	trigger.rb

	Arquivo para a classe usada para criação de gatilhos que podem ser 
	colocados no mundo do jogo para executar uma ação quando uma condição for 
	cumprida

=end

#==============================================================================
# Trigger
#------------------------------------------------------------------------------
# Classe para os gatilhos
#==============================================================================
class Trigger
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize condition, once = true, &action
		@condition = condition
		@action = action
		@once = once

		$world.add_trigger self
	end
	#--------------------------------------------------------------------------
	# Atualiza o gatilho: testa a condição e chama a ação de necessário
	#--------------------------------------------------------------------------
	def update
		if @condition.call
			@action.call
			dispose if @once
		end
	end
	#--------------------------------------------------------------------------
	# Libera o gatilho da memória
	#--------------------------------------------------------------------------
	def dispose
		$world.remove_trigger self
	end
end