class SMC

  def initialize()
    @pilhaValor = []
    @memoria = ["x",5,"y",1]
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

  def topoControle()
    @pilhaControle[0]
  end

  #deciders
  def ci_ev()
    aux = self.desempilhaControle()
    if(topoControle == 'ident')
      self.desempilhaControle()
      self.ci(aux)
    else
      self.ev(aux)
    end
  end

  def cwhilee()
    self.desempilhaControle
    bool = self.desempilhaValor()
    if(bool)
      self.cwhilee1()
    else
      self.cwhilee2()
    end
  end

  #plotkin
  def en()
    aux = self.desempilhaControle()
    self.empilhaValor(aux)
  end

  def ev(aux)
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

  def ci(aux)
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

  def bt()
    aux = self.desempilhaControle()
    self.empilhaValor(aux)
  end

  def be()
    val1 = self.desempilhaValor()
    val2 = self.desempilhaValor()
    operator = self.desempilhaControle()
    case operator
      when 'eq'
        resp = (val1 == val2)
        self.empilhaValor(resp)
      when 'gt'
        resp = (val1 < val2)
        self.empilhaValor(resp)
      when 'ge'
        resp = (val1 <= val2)
        self.empilhaValor(resp)
      when 'lt'
        resp = (val1 > val2)
        self.empilhaValor(resp)
      when 'le'
        resp = (val1 >= val2)
        self.empilhaValor(resp)
    end
  end

  def bnote()
    val1 = self.desempilhaValor()
    self.desempilhaControle()
    val1 = (!val1)
    self.empilhaValor(val1)
  end

  def cwhilee1()
    bloco = []
    i = 0
    aux = 1

    while(aux != 'fimloop')
      aux = @pilhaControle[i]
      bloco.push(aux)
      i += 1
    end
    @pilhaControle.unshift('loop')
    @pilhaControle.unshift(*bloco)
  end

  def cwhilee2()
    aux = self.desempilhaControle
    while(aux != 'fimloop')
      aux = self.desempilhaControle
    end
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
