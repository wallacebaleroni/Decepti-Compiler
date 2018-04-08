class SMC

  def initialize()
    @pilhaValor = []
    @pilhaMemoria = []
    @pilhaControle = []
  end

  def tamPilhaControle()
    @pilhaControle.length
  end

  def empilhaValor(valor)
    @pilhaValor.unshift(valor)
    puts(@pilhaValor)
    puts('----Valor------')
  end

  def empilhaMemoria(memoria)
    @pilhaMemoria.unshift(memoria)
    puts(@pilhaMemoria)
    puts('-----Memoria-----')
  end

  def empilhaControle(controle)
    @pilhaControle.unshift(controle)
    puts(@pilhaControle)
    puts('-----Controle-----')
  end

  def desempilhaValor()
    @pilhaValor.shift()
  end

  def desempilhaMemoria()
    @pilhaMemoria.shift()
  end

  def desempilhaControle()
    @pilhaControle.shift()
  end

end

