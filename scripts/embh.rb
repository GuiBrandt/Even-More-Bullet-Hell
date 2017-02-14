=begin

	embh.rb

	Arquivo principal do jogo, junta as classes e módulos necessários para
	fazer a parte divertida

=end

#==============================================================================
# Constantes
#==============================================================================

# Fator pelo qual dividir as velocidades
VELOCITY_DOWNSCALE_FACTOR = 600.0

# Número inicial de vidas do jogador
INITIAL_LIFES = 5

# Número máximo de vidas do jogador
MAX_LIFES = 10

# Velocidade do jogador
PLAYER_SPEED = 1.0 / 135.0
PLAYER_FAST_SPEED = PLAYER_SPEED * 1.75

# Intervalo em frames entre os tiros do jogador
PLAYER_SHOOT_COOLDOWN = 4

# Número de frames que um medidor de vida permanece na tela após o dano ao
# atirador relacionado ter ocorrido
LIFE_METER_FADE_TIME = 60

# Flag de uso de antialiasing
ANTIALIASING = true

#==============================================================================
# Módulos do jogo
#==============================================================================

# Funções legais
require 'embh/utils'

# Classes do jogo
require 'embh/world'
require 'embh/timer'

require 'embh/objects'
require 'embh/stage'

require 'embh/life_meter'

#==============================================================================
# Classes de objetos do jogo
#==============================================================================
def load_data folder, klass
	Dir.entries("data/#{folder}").each do |e|
		next unless e =~ /^(\w[\w\d]+)\.rb$/i

		name = $1
		name[0] = name[0].upcase

		Object.__send__(:eval,
				"class #{name} < #{klass}\r\n" + 
					File.read("data/#{folder}/#{e}") +
				"\r\nend"
		)
	end
end

load_data 'bullets', Bullet
load_data 'enemies', Enemy
load_data 'bonuses', Bonus
load_data 'stages',  Stage

#==============================================================================
# Inicialização
#==============================================================================

# AA
glEnable GL_POLYGON_SMOOTH if ANTIALIASING

# Tamanho da tela e frame skip
Graphics.resize_screen 600, 600
Graphics.max_frame_skip = 3

# Nome da classe do primeiro estágio
#FIRST_STAGE = Intro