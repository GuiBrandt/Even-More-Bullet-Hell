=begin

	bitmap.rb

	Alterações na classe Bitmap, usada para carregamento de imagens

=end

#==============================================================================
# Bitmap
#------------------------------------------------------------------------------
# Classe usada para carregar e manipular imagens
#==============================================================================
class Bitmap
	#--------------------------------------------------------------------------
	# Obtém os dados do bitmap na forma de uma string binária
	#--------------------------------------------------------------------------
	def data
		pixels = width * height 
		d = Array.new(pixels * 4)

		for i in 0...pixels
			r, g, b, a = *get_pixel(i % width, (i / width).truncate).to_4b
			d[i * 4, 4] = [b, g, r, a]
		end

		return d.pack("C*")
	end
end