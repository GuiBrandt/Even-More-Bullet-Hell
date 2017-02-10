=begin
	
	main.rb
	
	Arquivo principal do jogo, junta todas as partes e faz a magia acontecer

=end

require 'bzengine'
Graphics.setup

require 'embh'

bz_main do
	$world = World.new
	$player = Player.new

	Enemy1.new 0, 0

	loop do	
		Graphics.update
		Input.update
		
		$player.process_input
		$world.update
		$world.draw
	end
end