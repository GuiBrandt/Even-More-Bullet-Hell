=begin
	
	main.rb
	
	Arquivo principal do jogo, junta todas as partes e faz a magia acontecer

=end

require 'bzengine'
Graphics.setup

require 'embh'

game_over_txt = Bitmap.new(512, 256)
game_over_txt.font.outline = false

game_over_txt.font.size = 72
game_over_txt.draw_text(0, 0, 512, 128, "You Died", 1)

game_over_txt.font.size = 18
game_over_txt.draw_text(0, 128, 512, 64, "Press F12 to restart", 1)

spr = Sprite.new game_over_txt, 0, 0, 1, 1.0 / 2.0
game_over_txt.dispose

bz_main do
	$world = World.new
	$player = Player.new

	Enemy1.new 0, 0
	#Stage.start_game

	loop do	
		Graphics.update
		Input.update
		
		$world.draw
		
		if $player.dead?
			spr.draw
		else
			$player.process_input
		end
		
		$world.update
	end
end