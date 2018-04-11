class SMC

  def initialize()
    @pilhaValor = []
    @memoria = []
    @pilhaControle = []
  end

  def tamPilhaControle()
    @pilhaControle.length
  end

  def empilhaValor(valor)
    @pilhaValor.unshift(valor)
    puts("---------#{@pilhaControle}---------#{@pilhaValor}---------")
    puts("---------Controle---------Valor---------")
    puts()
  end


  def empilhaControle(controle)
    @pilhaControle.unshift(controle)
    puts("---------#{@pilhaControle}---------#{@pilhaValor}---------")
    puts("---------Controle---------Valor---------")
    puts()
  end

  def desempilhaValor()
    @pilhaValor.shift()
  end

  def desempilhaControle()
    @pilhaControle.shift()
  end

  def acessaMemoria(variavel)
    indice = @memoria.index(variavel)
    @memoria[indice+1]
  end

  def escreveMemoria(variavel, dado)
    indice = @memoria.index(variavel)
    if(indice)
      @memoria[indice+1] = dado
    else
      @memoria.push(variavel)
      @memoria.push(dado)
    end
    puts(@memoria)
  end

end

=begin
smc = SMC.new
smc.escreveMemoria("teste",2)
puts("----------")
smc.escreveMemoria("teste2","julia")
puts("----------")
smc.escreveMemoria("teste3",40)
puts("----------")
puts(smc.acessaMemoria("teste2"))
puts(smc.acessaMemoria("teste"))
puts(smc.acessaMemoria("teste3"))
puts("--------")
smc.escreveMemoria('teste2',"vacilona")
puts("--------")
puts(smc.acessaMemoria("teste2"))
=end