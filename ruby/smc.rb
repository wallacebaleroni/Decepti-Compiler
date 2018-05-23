class SMC

  def initialize()
    @addresses = 0
    @environment = [{}]
    @S = []
    @M = {}
    @C = []
    @reservado = ["add","sub","div","mul","eq","le","lt","ge","gt","neg","assign","if","while","print","and","or","seq","proc","var"]
  end

  def lengthC()
    @C.length
  end

  def length_environment()
    @environment.length
  end

  def to_s()
      puts("Controle      #{@C}")
      puts("Valor         #{@S}")
      puts("Memoria       #{@M}")
      puts("Ambiente      #{@environment}")
      puts()
  end

  def pushS(valor)
    @S.unshift(valor)
    puts("Controle   #{@C}")
    puts("Valor      #{@S}")
    puts()
  end

  def pushC(controle)
    @C.unshift(controle)
    puts("Controle   #{@C}")
    puts("Valor      #{@S}")
    puts()
  end

  def popS()
    @S.shift()
  end

  def popC()
    @C.shift()
  end

  def readM(variavel)
    endVar = @environment[variavel]
    @M[endVar]
  end

  def writeM(variavel, dado)
    endVar = @environment[0][variavel]
    @M[endVar] = dado
    puts("Ambiente   #{@environment}")
    puts("Memoria    #{@M}")
  end

  def writeE(variavel)
    if (@reservado.include?(variavel))
      raise "Palavra reservada usada como identificador"
    end

    new_env = Hash.new
    new_env = @environment[0].clone
    new_env[variavel] = @addresses
    @environment.unshift(new_env)
    @addresses += 1
    puts("Ambiente  #{@environment}")

  end

  def topC()
    @C[0]
  end

end
