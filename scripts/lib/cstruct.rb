=begin
	
	cstruct.rb

    Arquivo com a definição do módulo usado para manipular strings como se 
    fossem structs em C

=end

#==============================================================================
# CStruct
#------------------------------------------------------------------------------
# Módulo usado para criar structs C
#==============================================================================
module CStruct

	#---------------------------------------------------------------------------
	# Cria uma struct C com os campos desejados
	#
	# => fields 	: Campos da struct, deve ser um hashmap no formato 
	# 				  `nome: tamanho_em_bytes`
	#---------------------------------------------------------------------------
	def self.create(fields)
		_template = CStructTemplate.new(fields)

		return _template
	end

	#==========================================================================
	# CStructTemplate
	#--------------------------------------------------------------------------
	# Classe para as structs C
	#==========================================================================
	class CStructTemplate
		#----------------------------------------------------------------------
		# Construtor, inicializa o modelo
		#----------------------------------------------------------------------
		def initialize(fields)
			@_fields = fields
		end
		#----------------------------------------------------------------------
		# Tamanho total da struct em bytes
		#----------------------------------------------------------------------
		def size
			return @_fields.values.inject(0) {|r, v| r + v }
		end
		#----------------------------------------------------------------------
		# Cria uma instância da struct
		#----------------------------------------------------------------------
		def new
			_inst = ([0] * size).pack('C*')

			_inst.instance_variable_set('@_offsets'.to_sym, {})
			_inst.instance_variable_set('@_sizes'.to_sym, {})

			i = 0

			for k, v in @_fields
				_inst.instance_variable_get('@_offsets'.to_sym)[k] = i
				_inst.instance_variable_get('@_sizes'.to_sym)[k] = v

				i += v
			end

			class << _inst

				alias _slice []

				def [](name)
					name = name.to_sym
					return _slice(@_offsets[name], @_sizes[name])
				end

				alias _slice_set []=

				def []=(name, value)
					sz = @_sizes[name]
	
					value = [value].pack("Q")[0, sz] if value.is_a? Integer
					
					name = name.to_sym
					return _slice_set(@_offsets[name], sz, value[0, sz])
				end
				
				def inspect
					r = ""
					@_offsets.each do |a, b|
						r << "#{a} = #{_slice(b, @_sizes[a]).unpack("Q*L*S*C*").first}\n"
					end
					r
				end

			end

			return _inst
		end
	end
end