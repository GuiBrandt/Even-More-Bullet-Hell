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
INITIAL_LIFES = 3

# Velocidade do jogador
PLAYER_SPEED = 1.0 / 135.0
PLAYER_FAST_SPEED = PLAYER_SPEED * 1.75

PLAYER_SHOOT_COOLDOWN = 4

#==============================================================================
# Módulos do jogo
#==============================================================================

# Funções legais
require 'embh/utils'

# Classes do jogo
require 'embh/world'

require 'embh/objects'
require 'embh/bullets'

#==============================================================================
# Inicialização
#==============================================================================
glEnable GL_POLYGON_SMOOTH

Graphics.resize_screen 600, 600

$world = World.new
$player = Player.new