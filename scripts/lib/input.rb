=begin

  input.rb

  Reescrita do módulo de Input

=end

#==============================================================================
# Input
#------------------------------------------------------------------------------
# Módulo usado para controle de entrada pelo teclado no jogo
#==============================================================================
module Input
	class << self
		extend DLLImport

		KEYS = {
			BACKSPACE: 0x08, TAB:     0x09, ENTER:  0x0D, SHIFT: 0x10, CAPS:    0x14,  
			ESC:       0x1B, SPACE:   0x20, DELETE: 0x2E, CTRL:  0x11, ALT:     0x12,
			END:       0x23, INSERT:  0x2D, PGDN:   0x22, PGUP:  0x21, MOUSE_L: 0x01,
			MOUSE_R:   0x02, MOUSE_M: 0x04, PAUSE:  0x13,

			K0: 0x30, K1: 0x31, K2: 0x32, K3: 0x33, K4: 0x34, K5: 0x35, K6: 0x36, 
			K7: 0x37, K8: 0x38, K9: 0x39,

			N0: 0x60, N1: 0x61, N2: 0x62, N3: 0x63, N4: 0x64, N5: 0x65, N6: 0x66, 
			N7: 0x67, N8: 0x68, N9: 0x69,

			A: 0x41, B: 0x42, C: 0x43, D: 0x44, E: 0x45, F: 0x46, G: 0x47, H: 0x48, 
			I: 0x49, J: 0x4A, K: 0x4B, L: 0x4C, M: 0x4D, N: 0x4E, O: 0x4F, P: 0x50, 
			Q: 0x51, R: 0x52, S: 0x53, T: 0x54, U: 0x55, V: 0x56, W: 0x57, X: 0x58, 
			Y: 0x59, Z: 0x5A, Ç: 0xBA,

			MULTIPLY: 0x6A, ADD:      0x6B, SEPARATOR: 0x6C, SUBTRACT: 0x6D, 
			DECIMAL:  0x6E, DIVIDE:   0x6F, PLUS:      0xBB, COMMA:    0xBC, 
			MINUS:    0xBD, DOT:      0xBE, COLON:     0xBF, LASH:     0xC1,
			ACCUTE:   0xDB, QUOTE:    0xC0, BRACKET:   0xDD, BRACKET2: 0xDC,
			BACKLASH: 0xE2, TIL:      0xDE,

			F1:  0x70, F2:  0x71, F3:  0x72, F4:  0x73, F5:  0x74, F6:  0x75, 
			F7:  0x76, F8:  0x77, F9:  0x78, F10: 0x79, F11: 0x7A, F12: 0x7B, 
			F13: 0x7C, F14: 0x7D, F15: 0x7E, F16: 0x7F, F17: 0x80, F18: 0x81, 
			F19: 0x82, F20: 0x83, F21: 0x84, F22: 0x85, F23: 0x86, F24: 0x87,
		}

		LOWCASE = {
			BACKSPACE: "\b", TAB: "\t", ENTER: "\n", SPACE: ' ',

			K0: '0', K1: '1', K2: '2', K3: '3', K4: '4', K5: '5', K6: '6', 
			K7: '7', K8: '8', K9: '9',

			N0: '0', N1: '1', N2: '2', N3: '3', N4: '4', N5: '5', N6: '6', 
			N7: '7', N8: '8', N9: '9',

			A: 'a', B: 'b', C: 'c', D: 'd', E: 'e', F: 'f', G: 'g', H: 'h', 
			I: 'i', J: 'j', K: 'k', L: 'l', M: 'm', N: 'n', O: 'o', P: 'p', 
			Q: 'q', R: 'r', S: 's', T: 't', U: 'u', V: 'v', W: 'w', X: 'x', 
			Y: 'y', Z: 'z', Ç: 'ç',

			MULTIPLY: '*',  ADD:      '+', SEPARATOR: '.', SUBTRACT: '-', 
			DECIMAL:  ',',  DIVIDE:   '/', PLUS:      '=', COMMA:    ',', 
			MINUS:    '-',  DOT:      '.', COLON:     ';', LASH:     '/',
			ACCUTE:   '´',  QUOTE:    "'", BRACKET:   '[', BRACKET2: ']',
			BACKLASH: '\\', TIL:      '~',
		}

		UPCASE = {
			BACKSPACE: "\b", TAB: "\t", ENTER: "\n", SPACE: ' ',

			K0: ')', K1: '!', K2: '@', K3: '#', K4: '$', K5: '%', K6: '¨', 
			K7: '&', K8: '*', K9: '(',

			N0: '0', N1: '1', N2: '2', N3: '3', N4: '4', N5: '5', N6: '6', 
			N7: '7', N8: '8', N9: '9',

			A: 'A', B: 'B', C: 'C', D: 'D', E: 'E', F: 'F', G: 'G', H: 'H', 
			I: 'I', J: 'J', K: 'K', L: 'L', M: 'M', N: 'N', O: 'O', P: 'P', 
			Q: 'Q', R: 'R', S: 'S', T: 'T', U: 'U', V: 'V', W: 'W', X: 'X', 
			Y: 'Y', Z: 'Z', Ç: 'Ç',

			MULTIPLY: '*', ADD:      '+', SEPARATOR: '.', SUBTRACT: '-', 
			DECIMAL:  ',', DIVIDE:   '/', PLUS:      '+', COMMA:    '<', 
			MINUS:    '_', DOT:      '>', COLON:     ':', LASH:     '?',
			ACCUTE:   '`', QUOTE:    '"', BRACKET:   '{', BRACKET2: '}',
			BACKLASH: '|', TIL:      '^',
		}

		ACCENTS = %w(´ ~ ^ ` ¨)
		ACCENTABLE = %w(a A e E i I o O u U y Y)
		ACCENTED = {
			'a' => %w(á ã â à ä),    'A' => %w(Á Ã Ã À Ä),
			'e' => %w(é ~e ê è ë),   'E' => %w(É ~E Ê È Ë),
			'i' => %w(í ~i î ì ï),   'I' => %w(Í ~I Î Ì Ï),
			'o' => %w(ó õ ô ò ö),    'O' => %w(Ó Õ Ô Ò Ö),
			'u' => %w(ú ~u û ù ü),   'U' => %w(Ú ~U Û Ù Ü),
			'y' => %w(ý ~y ^y `y ÿ), 'Y' => %w(Ý ~Y ^Y `Y ¨Y),
		}

		with_dll('user32') do
			import :GetAsyncKeyState, :long
		end

		@@_trigger = []
		@@_counter = []
		@@_accent  = ''

		#--------------------------------------------------------------------------
		# Checks if a key was pressed
		#--------------------------------------------------------------------------
		def press?(key)
			GetAsyncKeyState(code(key)) >> 8 != 0
		end
		#--------------------------------------------------------------------------
		# Checks ia key is toggled (e.g. Caps Lock)
		#--------------------------------------------------------------------------
		def toggle?(key)
			(GetAsyncKeyState(code(key)) & 1) != 0
		end
		#--------------------------------------------------------------------------
		# Checks if a key was triggered an pressed
		#--------------------------------------------------------------------------
		def repeat?(key)
			unless (GetAsyncKeyState(code(key) || 0) >> 8) == 0
				@@_trigger << key unless @@_trigger.include?(code(key)) 
				index = (@@_trigger.index(code(key)) || 0)
				@@_counter[index] = 0 unless @@_counter[index]
				@@_counter[index] += 1
				return true if @@_counter[index] == 1
				return (@@_counter[index] >= 30 && @@_counter[index] % 4 == 1)
			else
				index = @@_trigger.index(code(key)) if @@_trigger.include?(code(key))
				@@_counter[index] = nil if index
			end
		end
		#--------------------------------------------------------------------------
		# Checks if a key was triggered
		#--------------------------------------------------------------------------
		def trigger?(key)
			unless (GetAsyncKeyState(code(key)) >> 8) == 0
				@@_trigger.include?(code(key)) ? (return false) : @@_trigger << code(key)
				return true
			else
				@@_trigger.delete(code(key)) if @@_trigger.include?(code(key))
				return false
			end
		end
		#--------------------------------------------------------------------------
		# Gets the virtual key code for a symbol
		#--------------------------------------------------------------------------
		def code(key)
			if key.is_a?(Symbol)
				return KEYS[key].to_i
			elsif key.is_a?(String)
				keys = LOWCASE.keys + UPCASE.keys
				values = LOWCASE.values + UPCASE.values
				return code(keys[values.index(key)]).to_i
			elsif key.is_a?(Integer)
				return key.to_i
			else
				raise ArgumentError.new
			end
		end
		#--------------------------------------------------------------------------
		# Gets the symbol for a virtual key code
		#--------------------------------------------------------------------------
		def key(code)
			KEYS.keys[KEYS.values.index code]
		end
		#--------------------------------------------------------------------------
		# Gets the uppercase representation of a key
		#--------------------------------------------------------------------------
		def upcase(key)
			UPCASE[KEYS.keys[KEYS.values.index code(key)]] || ''
		end
		#--------------------------------------------------------------------------
		# Gets the lowercase representation of a key
		#--------------------------------------------------------------------------
		def lowcase(key)
			LOWCASE[KEYS.keys[KEYS.values.index code(key)]] || ''
		end
		#--------------------------------------------------------------------------
		# Checks if the Shift key is pressed or Caps Lock is toggled
		#--------------------------------------------------------------------------
		def shift?
			press?(0x10) || toggle?(0x14)
		end
		#--------------------------------------------------------------------------
		# Gets the code for the key being pressed
		#--------------------------------------------------------------------------
		def pressed(mode = 0)
			k = nil
			KEYS.each_value do |v|
				b = false
				case mode
					when 0
						b = press?(v)
					when 1
						b = repeat?(v)
					else
						b = trigger?(v)
				end
				k = v if b
			end
			k
		end
		#--------------------------------------------------------------------------
		# Gets the char for the key being pressed
		#--------------------------------------------------------------------------
		def char(mode = 0)
			key = pressed(mode)
			return '' unless key
			c = (shift? ? upcase(key) : lowcase(key)) || ''
			return c
		end
		#--------------------------------------------------------------------------
		# Gets the UTF-8 representation of the key being pressed
		#--------------------------------------------------------------------------
		def utf8(mode = 1)
			chr = char(mode)
			return chr if chr.empty?
			if ACCENTS.include?(chr) && @@_accent.empty?
				@@_accent = chr
				return ''
			else
				if !@@_accent.empty? && ACCENTABLE.include?(chr)
					acnt = @@_accent
					@@_accent = ''
					return ACCENTED[chr][ACCENTS.index(acnt)]
				elsif !@@_accent.empty?
					acnt = @@_accent
					@@_accent = ''
					return acnt + chr
				end
			end
			return chr || ''
		end
	end
end