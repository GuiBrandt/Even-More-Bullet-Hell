=begin

	buffers.rb

	Classes para controle de buffers de vértice para uso com o OpenGL

=end

#==============================================================================
# VertexBuffer
#------------------------------------------------------------------------------
# Classe usada para manipular buffers de vértice do OpenGL
#==============================================================================
class VertexBuffer
	attr_reader :vertex_size, :vertex_count, :id, :data

	#--------------------------------------------------------------------------
	# Construtor
	#
	# => vertex_size	: Número de coordenadas por vértice
	# => vertex_count	: Número de vértices
	# => usage			: Tipo de buffer (Opcional)
	#--------------------------------------------------------------------------
	def initialize vertex_size, vertex_count, usage = GL_DYNAMIC_DRAW
		@id = [0].pack("L")
		glGenBuffers 1, @id.cptr
		@id = @id.unpack("L").first

		@vertex_size = vertex_size
		@vertex_count = vertex_count

		@data = Array.new(vertex_size * vertex_count) { 0 }

		d = @data.pack("f*")
		self.bind
		glBufferData GL_ARRAY_BUFFER, d.size, d.cptr, usage
	end
	#--------------------------------------------------------------------------
	# Altera os dados do buffer
	#--------------------------------------------------------------------------
	def data=(array)
		self.bind

		@data = array
		d = @data.pack("f*")
		glBufferSubData GL_ARRAY_BUFFER, 0, d.size, d.cptr
	end
	#--------------------------------------------------------------------------
	# Obtém um ponteiro para os dados do buffer
	#--------------------------------------------------------------------------
	def cptr
		return @data.pack("f*").cptr
	end
	#--------------------------------------------------------------------------
	# Obtém um vértice
	#--------------------------------------------------------------------------
	def [](index)
		return @data
	end
	#--------------------------------------------------------------------------
	# Altera um vértice
	#--------------------------------------------------------------------------
	def []=(index, *args)
		@data[index * @vertex_size, @vertex_size] = args[0, @vertex_size]
		self.data = @data
	end
	#--------------------------------------------------------------------------
	# Define o buffer como o buffer ativo
	#--------------------------------------------------------------------------
	def bind
		glBindBuffer GL_ARRAY_BUFFER, @id
	end
	#--------------------------------------------------------------------------
	# Desenha o buffer
	#--------------------------------------------------------------------------
	def draw mode = GL_TRIANGLES
		self.bind

		glEnableVertexAttribArray 0
		glVertexAttribPointer 0, @vertex_size, GL_FLOAT, GL_FALSE, 0, 0
		glDrawArrays mode, 0, @vertex_count
		glDisableVertexAttribArray 0
	end
	#--------------------------------------------------------------------------
	# Libera o buffer da memória
	#--------------------------------------------------------------------------
	def dispose
		glDeleteBuffers 1, [@id].pack('L').cptr
	end
end
#==============================================================================
# IndexBuffer
#------------------------------------------------------------------------------
# Classe usada para manipular buffers de índice do OpenGL
#==============================================================================
class IndexBuffer
	attr_reader :index_count, :id, :data

	#--------------------------------------------------------------------------
	# Construtor
	#
	# => index_count	: Número de índices
	# => usage			: Tipo de buffer (Opcional)
	#--------------------------------------------------------------------------
	def initialize index_count, usage = GL_DYNAMIC_DRAW
		@id = [0].pack("L")
		glGenBuffers 1, @id.cptr
		@id = @id.unpack("L").first

		@index_count = index_count

		@data = Array.new(index_count) { 0 }

		d = @data.pack("S*")

		self.bind
		glBufferData GL_ELEMENT_ARRAY_BUFFER, d.size, d.cptr, usage
	end
	#--------------------------------------------------------------------------
	# Altera os dados do buffer
	#--------------------------------------------------------------------------
	def data=(array)
		self.bind

		@data = array
		d = @data.pack("S*")
		glBufferSubData GL_ELEMENT_ARRAY_BUFFER, 0, d.size, d.cptr
	end
	#--------------------------------------------------------------------------
	# Obtém um ponteiro para os dados do buffer
	#--------------------------------------------------------------------------
	def cptr
		return @data.pack("S*").cptr
	end
	#--------------------------------------------------------------------------
	# Obtém um índice
	#--------------------------------------------------------------------------
	def [](index)
		return @data
	end
	#--------------------------------------------------------------------------
	# Altera um índice
	#--------------------------------------------------------------------------
	def []=(index, other_index)
		@data[index] = other_index
		self.data = @data
	end
	#--------------------------------------------------------------------------
	# Define o buffer como o buffer ativo
	#--------------------------------------------------------------------------
	def bind
		glBindBuffer GL_ELEMENT_ARRAY_BUFFER, @id
	end
	#--------------------------------------------------------------------------
	# Desenha o buffer
	#--------------------------------------------------------------------------
	def draw vbo, mode = GL_TRIANGLES
		vbo.bind
		self.bind

		glEnableVertexAttribArray 0
		glVertexAttribPointer 0, vbo.vertex_size, GL_FLOAT, GL_FALSE, 0, 0
		glDrawElements mode, @index_count, GL_UNSIGNED_SHORT, 0
		glDisableVertexAttribArray 0
	end
	#--------------------------------------------------------------------------
	# Libera o buffer da memória
	#--------------------------------------------------------------------------
	def dispose
		glDeleteBuffers 1, [@id].pack('L').cptr
	end
end