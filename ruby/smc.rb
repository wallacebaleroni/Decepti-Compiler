class SMC

  def initialize()
    @addresses = 0
    @E = [{}]
    @S = []
    @M = {}
    @C = []
    @A = [[]]
    @reservado = ["add","sub","div","mul","eq","le","lt","ge","gt","neg","assign","if","while","print","and","or","seq","proc","var"]
  end

  def lengthC()
    @C.length
  end

  def lengthE()
    @E.length
  end

  def print_smc()
    puts("Ambiente      #{@E}")
    puts("Valor         #{@S}")
    puts("Controle      #{@C}")
    puts("Memoria       #{@M}")
    puts("Aux           #{@A}")
    puts()
  end

  def pushS(valor)
    @S.unshift(valor)
  end

  def pushC(controle)
    @C.unshift(controle)
  end

  def popS()
    @S.shift()
  end

  def popC()
    @C.shift()
  end

  def readM(variavel)
    endVar = @E[variavel]
    @M[endVar]
  end

  def writeM(variavel, dado)
    print(variavel)
    print(dado)
    endVar = @E[0][variavel]
    @M[endVar] = dado
  end

  def writeE(variavel)
    if (@reservado.include?(variavel))
      raise "Palavra reservada usada como identificador"
    end

    new_env = Hash.new
    new_env = @E[0].clone
    new_env[variavel] = @addresses
    @E.unshift(new_env)
    @addresses += 1

  end

  def topC()
    @C[0]
  end

  def desempilhaAmbiente()
    listaVar = @A.shift()
    for i in 1..listaVar.length
      @E.shift
    end
  end

end

