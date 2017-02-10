=begin

	graphics.rb

	Mudanças (quase reescrita na verdade) do módulo gráfico para usar OpenGL
	no desenho

=end

#==============================================================================
# Graphics
#------------------------------------------------------------------------------
# Módulo responsável por desenhar tudo na tela
#==============================================================================
module Graphics
    #--------------------------------------------------------------------------
    # Variáveis estáticas
    #--------------------------------------------------------------------------
	@@background = Color.new(0, 0, 0, 255)
	@@_set_up = false
	@@width = 544
	@@height = 416
	
	@@last_t = nil
	
	@@max_frame_skip = 0
	@@frame_skip = 0
	
    class << self
		#----------------------------------------------------------------------
		# Inicialização dos gráficos
		#----------------------------------------------------------------------
		def setup
			@@_set_up = true

			# Área de visão
			glViewport 0, 0, width, height
			
			# Transparência
			glEnable GL_BLEND
			glBlendFunc GL_SRC_ALPHA, GL_ONE
			
			# Shaders
			@@_clearProgram = ShaderProgram.new
			@@_clearProgram.add_vertex_shader 'basic_2d'
			@@_clearProgram.add_fragment_shader 'basic_rgba'
			@@_clearProgram.link
			
			# Buffers
			@@_screen_rect_buffer = VertexBuffer.new(2, 6, GL_STATIC_DRAW)
			@@_screen_rect_buffer.data = [
				-1,  1,
				 1,  1,
				 1, -1,
				 
				 1, -1,
				-1,  1,
				-1, -1,
			]
		end
		#----------------------------------------------------------------------
		# Limpeza da tela
		#----------------------------------------------------------------------
		def clear
			if background.alpha != 255				
				@@_clearProgram.use
				
				glUniform4f @@_clearProgram[:color], *background.to_4f
				
				@@_screen_rect_buffer.draw
			else
				glClearColor *background.to_4f
				glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
			end
		end
        #----------------------------------------------------------------------
        # Atualização da tela
        #----------------------------------------------------------------------
        alias upd update
        def update
			unless @@_set_up
				raise "Graphics module not initialized. " + 
					  "Call `Graphics.setup` before `Graphics.update`"
			end
		
			t = Time.now
			
			@@last_t ||= Time.now
			delta = t - @@last_t
			
            # Troca os buffers de desenho e exibição (double buffering \o/)
			#
			# Isso vai mostrar tudo que foi desenhado durante este frame na 
			# tela do jogo
            SwapBuffers(@@hdc)

            # Espera um frame
            frame = 1.0 / frame_rate
			
			@@frame_skip += delta * frame_rate
			@@frame_skip = [@@max_frame_skip, @@frame_skip].min
			
			skip = [1.0, @@frame_skip].min
			@@frame_skip -= skip
			
			until delta >= (1.0 - skip) * frame && GetActiveWindow() == @@hwnd
				delta = Time.now - @@last_t
			end
			
			# Limpa a tela
			clear
			
            self.frame_count += 1
			
			@@last_t = t
        end
        #----------------------------------------------------------------------
        # Aplica fadein na tela
        #----------------------------------------------------------------------
        def fadein *args
        end
        #----------------------------------------------------------------------
        # Aplica fadeout na tela
        #----------------------------------------------------------------------
        def fadeout *args
        end
        #----------------------------------------------------------------------
        # Aplica uma transição na tela
        #----------------------------------------------------------------------
        def transition *args
        end
        #----------------------------------------------------------------------
        # Handle de contexto de dispositivo
        #----------------------------------------------------------------------
        def hdc
            return @@hdc
        end
        #----------------------------------------------------------------------
        # Handle de contexto do WGL
        #----------------------------------------------------------------------
        def hglrc
            return @@hglrc
        end
        #----------------------------------------------------------------------
        # Handle da janela
        #----------------------------------------------------------------------
        def hwnd
            return @@hwnd
        end
		#----------------------------------------------------------------------
		# Cor do fundo da tela
		#----------------------------------------------------------------------
		def background
			return @@background
		end
		#----------------------------------------------------------------------
		# Define a cor de fundo da tela
		#----------------------------------------------------------------------
		def background= color
			@@background = color
		end
		#----------------------------------------------------------------------
		# Redimensiona a tela
		#----------------------------------------------------------------------
		def resize_screen width, height
			window_rect = RECT.new
			GetWindowRect @@hwnd, window_rect.cptr
			
			window_style = GetWindowLong @@hwnd, -16
			window_ex_style = GetWindowLong @@hwnd, -20
			
			left = window_rect[:left].unpack('L').first
			top = window_rect[:top].unpack('L').first
			
			window_rect[:right] = left + width
			window_rect[:bottom] = top + height
			
			AdjustWindowRectEx(
				window_rect.cptr, 
				window_style,
				0, 					# Sem menu
				window_ex_style
			)
			
			left = window_rect[:left].unpack('L').first
			top = window_rect[:top].unpack('L').first
			right = window_rect[:right].unpack('L').first
			bottom = window_rect[:bottom].unpack('L').first
			
			MoveWindow(
				@@hwnd,
				left,
				top,
				right - left,
				bottom - top,
				0
			)
			
			@@width = width
			@@height = height
			
			glViewport 0, 0, width, height
		end
		#----------------------------------------------------------------------
		# Obtém a largura da tela
		#----------------------------------------------------------------------
		def width
			return @@width
		end
		#----------------------------------------------------------------------
		# Obtém a altura da tela
		#----------------------------------------------------------------------
		def height
			return @@height
		end
		#----------------------------------------------------------------------
		# Define o máximo de frames a serem pulados caso haja lag
		# Pular frames evita desaceleração do jogo mas causa perda de suavidade
		# 
		# O padrão para este valor é 0
		#----------------------------------------------------------------------
		def max_frame_skip=(n)
			@@max_frame_skip = n
		end
		#----------------------------------------------------------------------
		# Verifica se um frame deveria ser pulado
		#----------------------------------------------------------------------
		def skip_frame?
			return @@frame_skip >= 1
		end
		#----------------------------------------------------------------------
		# Sinaliza que um frame foi pulado
		#----------------------------------------------------------------------
		def frame_skip
			@@frame_skip -= 1
		end
    end
end