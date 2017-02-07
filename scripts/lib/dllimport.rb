=begin

    dllimport.rb

    Arquivo com as funcionalidades necessárias para importação de funções de
    DLLs do Windows

=end

#==============================================================================
# DLLImport
#------------------------------------------------------------------------------
# Módulo com as funções de importação
#==============================================================================
module DLLImport
    include DL

    @@__current_dll = nil
    @@__dll_cache = {}
    @@__imported_functions = {}

    # Hashmap com os tipos de argumentos/retorno das funções
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
    # => existing   : Nome do tipo já existente
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
    # Abre uma DLL para importar funções
    # => dllname    : Nome da DLL que será aberta
    #
    # Essa função recebe um proc, dentro dele devem ser feitas as importações
    #---------------------------------------------------------------------------
    def with_dll dllname
        @@__dll_cache[dllname] ||= DL.dlopen dllname
        @@__current_dll = @@__dll_cache[dllname]
        yield
        @@__current_dll = nil
    end
    #---------------------------------------------------------------------------
    # Importa uma função da DLL
    #
    # => symbol     : Nome da função como symbol
    # => ret        : Especificador de tipo de retorno
    # => name       : Nome para o método que será criado (Opcional)
    #---------------------------------------------------------------------------
    def import symbol, ret, name = nil
        raise "You can't import a function without opening a DLL!" if !@@__current_dll

        name ||= symbol
        name = name.to_s.to_sym

        # Adiciona a função na lista de funções importadas
        unless @@__imported_functions[symbol]
            fname = symbol.to_s
            func = DL::CFunc.new @@__current_dll[fname], @@__types[ret], fname
            @@__imported_functions[symbol] = func
        end

        # Cria o método para a função
        define_method(name) do |*args|

            # Ajuste para parâmetros de ponto flutuante, se você não entendeu
            # então fica tranquilo que a gente tá na mesma
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
# Adição de algumas funções obscuras para uso com DLLs na classe mãe de todos
# os objetos (a.k.a.: Tudo)
#==============================================================================
class Object
  #---------------------------------------------------------------------------
  # Obtém o ponteiro C do objeto e o retorna na forma de inteiro
  #---------------------------------------------------------------------------
  def cptr
    return DL::CPtr[self].to_i
  end
end
