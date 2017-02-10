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
	Enemy1.new 0.5, 0.5
	Enemy1.new -0.5, 0.5

	loop do	
		Graphics.update
		Input.update
		
		$player.process_input
		$world.draw
		
		if $player.dead?
			msgbox 'Game Over'
			raise RGSSReset.new
		end
		
		$world.update
	end
end