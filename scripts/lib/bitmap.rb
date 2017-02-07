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
			d[i * 4, 4] = get_pixel(i % width, (i / width).truncate).to_4b
		end

		return d.pack("C*")
	end
end