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
    puts("---------#{@memoria}---------")
    puts("----------Memoria----------")
  end

  def printa()
    puts(@pilhaControle)
  end

  #plotkin
  def en()
    aux = self.desempilhaControle()
    self.empilhaValor(aux)
  end

  def ev()
    aux = self.desempilhaControle()
    aux2 = self.acessaMemoria(aux)
    self.empilhaValor(aux2)
  end

  def ee()
    val1 = self.desempilhaValor()
    val2 = self.desempilhaValor()
    operator = self.desempilhaControle()
    case operator
      when 'add'
        resp = val1 + val2
        self.empilhaValor(resp)
      when 'sub'
        resp = val1 - val2
        self.empilhaValor(resp)
      when 'mul'
        resp = val1 * val2
        self.empilhaValor(resp)
      when 'div'
        resp = val1 / val2
        self.empilhaValor(resp)
    end
  end

  def ci()
    aux = self.desempilhaControle()
    self.empilhaValor(aux)
  end

  def ce()
    self.desempilhaControle()
    val = self.desempilhaValor()
    ident = self.desempilhaValor()
    self.escreveMemoria(ident,val)
  end

  def cnil()
    self.desempilhaControle
  end

  def topoControle()
    @pilhaControle[0]
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
