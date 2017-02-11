=begin

	textures.rb

	Arquivo com as classes usadas para manipulação e desenho de texturas do 
	OpenGL

=end

#==============================================================================
# Texture
#------------------------------------------------------------------------------
# Classe usada para representar uma textura
#==============================================================================
class Texture
	attr_reader :id
	#--------------------------------------------------------------------------
	# Construtor
	#--------------------------------------------------------------------------
	def initialize bitmap, min_filter = GL_LINEAR_MIPMAP_LINEAR, 
							mag_filter = GL_LINEAR,
					mipmaps = true
		@id = [0].pack('L')
		glGenTextures 1, @id.cptr
		@id = @id.unpack('L').first

		self.bind
		glTexImage2D(
			GL_TEXTURE_2D, 
			0, 
			GL_RGBA8, 
			bitmap.width, bitmap.height, 
			0,
			GL_BGRA, GL_UNSIGNED_BYTE, 
			bitmap.data.cptr
		)

		glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, min_filter
		glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, mag_filter
		glGenerateMipmap(GL_TEXTURE_2D) if mipmaps
	end
	#--------------------------------------------------------------------------
	# Liga a textura
	#--------------------------------------------------------------------------
	def bind
		glBindTexture GL_TEXTURE_2D, @id
	end
	#--------------------------------------------------------------------------
	# Libera a textura da memória
	#--------------------------------------------------------------------------
	def dispose
		glDeleteTextures 1, [@id].pack('L').cptr
	end
end