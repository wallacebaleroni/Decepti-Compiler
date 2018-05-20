class SMC

  def initialize()
    @addresses = 0
    @environment = [{}]
    @S = []
    @M = {}
    @C = []
  end

  def lengthC()
    @C.length
  end

  def length_environment()
    @environment.length
  end

  def to_s()
      puts("Controle   #{@C}")
      puts("Valor      #{@S}")
      puts("Memoria      #{@M}")
      puts("Ambiente      #{@environment}")
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
    lastenvironment = Hash.new
    lastenvironment = @environment[0].clone
    lastenvironment[variavel] = @addresses
    @environment.unshift(lastenvironment)
    @addresses += 1
    puts("Ambiente   #{@environment}")
  end

  def topC()
    @C[0]
  end

end
