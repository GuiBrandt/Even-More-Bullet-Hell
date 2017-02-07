=begin

    dllimport.rb

    Arquivo com as funcionalidades necess�rias para importa��o de fun��es de
    DLLs do Windows

=end

#==============================================================================
# DLLImport
#------------------------------------------------------------------------------
# M�dulo com as fun��es de importa��o
#==============================================================================
module DLLImport
    include DL

    @@__current_dll = nil
    @@__dll_cache = {}
    @@__imported_functions = {}

    # Hashmap com os tipos de argumentos/retorno das fun��es
    @@__types = {
        :long    => TYPE_LONG,
        :int     => TYPE_INT,
        :short   => TYPE_SHORT,
        :char    => TYPE_CHAR,
        :double  => TYPE_DOUBLE,
        :float   => TYPE_FLOAT,
        :void    => TYPE_VOID,
        :pointer => TYPE_VOIDP
    }
    #---------------------------------------------------------------------------
    # Cria um alias para um tipo
    # => existing   : Nome do tipo j� existente
    # => new        : Nome do novo tipo
    #---------------------------------------------------------------------------
    def typedef existing, new
        if @@__types.keys.include? existing
            @@__types[new] = @@__types[existing]
        else
            raise "Undefined type '#{existing}'"
        end
    end
    #---------------------------------------------------------------------------
    # Abre uma DLL para importar fun��es
    # => dllname    : Nome da DLL que ser� aberta
    #
    # Essa fun��o recebe um proc, dentro dele devem ser feitas as importa��es
    #---------------------------------------------------------------------------
    def with_dll dllname
        @@__dll_cache[dllname] ||= DL.dlopen dllname
        @@__current_dll = @@__dll_cache[dllname]
        yield
        @@__current_dll = nil
    end
    #---------------------------------------------------------------------------
    # Importa uma fun��o da DLL
    #
    # => symbol     : Nome da fun��o como symbol
    # => ret        : Especificador de tipo de retorno
    # => name       : Nome para o m�todo que ser� criado (Opcional)
    #---------------------------------------------------------------------------
    def import symbol, ret, name = nil
        raise "You can't import a function without opening a DLL!" if !@@__current_dll

        name ||= symbol
        name = name.to_s.to_sym

        # Adiciona a fun��o na lista de fun��es importadas
        unless @@__imported_functions[symbol]
            fname = symbol.to_s
            func = DL::CFunc.new @@__current_dll[fname], @@__types[ret], fname
            @@__imported_functions[symbol] = func
        end

        # Cria o m�todo para a fun��o
        define_method(name) do |*args|

            # Ajuste para par�metros de ponto flutuante, se voc� n�o entendeu
            # ent�o fica tranquilo que a gente t� na mesma
            args.size.times do |i|
                if args[i].is_a? Float
                    args[i] = [args[i]].pack('g').unpack('H16').first.to_i(16)
                end
            end

            return @@__imported_functions[symbol].call args
        end
    end
end
#==============================================================================
# Object
#------------------------------------------------------------------------------
# Adi��o de algumas fun��es obscuras para uso com DLLs na classe m�e de todos
# os objetos (a.k.a.: Tudo)
#==============================================================================
class Object
  #---------------------------------------------------------------------------
  # Obt�m o ponteiro C do objeto e o retorna na forma de inteiro
  #---------------------------------------------------------------------------
  def cptr
    return DL::CPtr[self].to_i
  end
end
