=begin
	
	main.rb
	
	Arquivo principal do jogo, junta todas as partes e faz a magia acontecer

=end

require 'bzengine'

Graphics.setup

bz_main do
	loop do		
		Graphics.update
		Input.update
	end
end