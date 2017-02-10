=begin

	bzengine.rb
	
	Arquivo principal da engine, carrega todos os módulos necessários

=end

#==============================================================================
# Carregamento das bibliotecas da engine
#==============================================================================

# Remoção de coisas desnecessárias
require 'lib/undefs'

# Interação com interfaces nativas (Win32API)
require 'lib/cstruct'
require 'lib/dllimport'

# Biblioteca de funções gráficas (OpenGL)
require 'lib/opengl'
require 'lib/shaders'
require 'lib/buffers'
require 'lib/graphics'
require 'lib/color'
require 'lib/bitmap'

# Funções dos controles
require 'lib/input'