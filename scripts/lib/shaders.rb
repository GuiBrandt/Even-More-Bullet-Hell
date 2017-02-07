=begin

	shaders.rb

	Arquivo com as classes e módulos usados para controle dos shaders

=end

#==============================================================================
# ShaderProgram
#------------------------------------------------------------------------------
# Classe usada para manipulação dos programas de shader
#==============================================================================
class ShaderProgram
	attr_reader :id, :linked

	#--------------------------------------------------------------------------
	# Construtor
	#
	# Cria um programa de shaders
	#--------------------------------------------------------------------------
	def initialize
		@id = glCreateProgram
		@shaders = []
		@linked = false
	end
	#--------------------------------------------------------------------------
	# Adiciona um shader de vértice ao programa a partir de um arquivo
	#--------------------------------------------------------------------------
	def add_vertex_shader name
		raise 'O programa já está linkado, não é possível adicionar mais shaders' if @linked
	
		file = File.open "shaders/#{name}.vert"
		source = file.read
		file.close
		
		shader = glCreateShader GL_VERTEX_SHADER
		glShaderSource shader, 1, [source.cptr].pack("L").cptr, 0
		glCompileShader shader
		
		info_log_length = [0].pack("L")
		glGetShaderiv shader, GL_INFO_LOG_LENGTH, info_log_length.cptr
		info_log_length = info_log_length.unpack("L")[0]
		
		if info_log_length > 0
			err = "\0" * (info_log_length + 1)
			glGetShaderInfoLog shader, info_log_length, 0, err.cptr
			raise "Falha ao compilar shader de vértice `#{name}`: #{err}"
		end
		
		glAttachShader @id, shader
		
		@shaders << shader
	end
	#--------------------------------------------------------------------------
	# Adiciona um shader de fragmento ao programa a partir de um arquivo
	#--------------------------------------------------------------------------
	def add_fragment_shader name
		raise 'O programa já está linkado, não é possível adicionar mais shaders' if @linked
		
		file = File.open "shaders/#{name}.frag"
		source = file.read
		file.close
		
		shader = glCreateShader GL_FRAGMENT_SHADER
		glShaderSource shader, 1, [source.cptr].pack("L").cptr, 0
		glCompileShader shader
		
		info_log_length = [0].pack("L")
		glGetShaderiv shader, GL_INFO_LOG_LENGTH, info_log_length.cptr
		info_log_length = info_log_length.unpack("L")[0]
		
		if info_log_length > 0
			err = "\0" * (info_log_length + 1)
			glGetShaderInfoLog shader, info_log_length, 0, err.cptr
			raise "Falha ao compilar shader de fragmento `#{name}`: #{err}"
		end
		
		glAttachShader @id, shader
		
		@shaders << shader
	end
	#--------------------------------------------------------------------------
	# Faz as ligações do programa e deixa ele pronto para usar
	# Não será possível adicionar mais shaders depois disso
	#--------------------------------------------------------------------------
	def link
		glLinkProgram @id
		@linked = true
		
		for shader in @shaders
			glDetachShader @id, shader
			glDeleteShader shader
		end
	end
	#--------------------------------------------------------------------------
	# Ativa o programa de shaders
	#--------------------------------------------------------------------------
	def use
		glUseProgram @id
	end
	#--------------------------------------------------------------------------
	# Obtém o ID de um uniform
	#--------------------------------------------------------------------------
	def [](uniform_name)
		return glGetUniformLocation @id, uniform_name.to_s.cptr
	end
end