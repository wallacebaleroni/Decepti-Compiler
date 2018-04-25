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
    puts("Controle   #{@pilhaControle}")
    puts("Valor      #{@pilhaValor}")
    puts()
  end

  def empilhaControle(controle)
    @pilhaControle.unshift(controle)
    puts("Controle   #{@pilhaControle}")
    puts("Valor      #{@pilhaValor}")
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
    if indice
      @memoria[indice+1] = dado
    else
      @memoria.push(variavel)
      @memoria.push(dado)
    end
    puts("Memoria    #{@memoria}")
  end

  def topoControle()
    @pilhaControle[0]
  end

  # Deciders
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
    self.desempilhaControle()
    bool = self.desempilhaValor()
    if(bool)
      self.cwhilee1()
    else
      self.cwhilee2()
    end
  end

  # Plotkin
  def en()
    puts("En")
    aux = self.desempilhaControle()
    self.empilhaValor(aux)
  end

  def ev(aux)
    puts("Ev")
    aux2 = self.acessaMemoria(aux)
    self.empilhaValor(aux2)
  end

  def ee()
    puts("E op E")
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
    puts("C := I")
    self.empilhaValor(aux)

  end

  def ce()
    puts("C := E")
    self.desempilhaControle()
    val = self.desempilhaValor()
    ident = self.desempilhaValor()
    self.escreveMemoria(ident,val)
  end

  def cnil()
    puts("C nil")
    puts()
    self.desempilhaControle
  end

  def bt()
    puts("Bt")
    aux = self.desempilhaControle()
    self.empilhaValor(aux)
  end

  def be()
    puts("B = E")
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
    puts("B ~ E")
    val1 = self.desempilhaValor()
    self.desempilhaControle()
    val1 = (!val1)
    self.empilhaValor(val1)
  end

  def cwhilee1()
    puts("C while E1")
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
    puts("C while E2")
    puts()
    aux = self.desempilhaControle
    while(aux != 'fimloop')
      aux = self.desempilhaControle
    end
  end

  def print()
    puts("Print")
    self.desempilhaControle

    puts(self.desempilhaValor)
    puts()
  end

  def csc()
    puts("C;")
    puts()
    self.desempilhaControle
  end

  def cife()
    puts("C if E")
    puts()
    self.desempilhaControle()
    bool = self.desempilhaValor()
    # Checa condição do if
    if(bool) # TRUE
      # Checa se existe 'else' apos o 'fimif'
      i = @pilhaControle.index('fimif')
      @pilhaControle[i] = nil # Remove o 'fimif'
      while(@pilhaControle[i] == nil)
        i += 1
      end
      if(@pilhaControle[i] == 'else')
        # Se existe, apaga o conteudo do else
        while(@pilhaControle[i] != 'fimelse')
          @pilhaControle[i] = nil
          i += 1
        end
        @pilhaControle[i] = nil
      end
    else # FALSE
      i = 0
      # Desempilha tudo antes do 'fimif'
      while(@pilhaControle[i] != 'fimif')
        self.desempilhaControle()
      end
      self.desempilhaControle() # Desempilha o 'fimif'

      # Checa se existe 'else' apos o 'fimif'
      i = 0
      while(@pilhaControle[i] == nil && self.tamPilhaControle > 0)
        i += 1
      end
      if(@pilhaControle[i] == 'else')
        self.desempilhaControle()
        # Se existe, apaga o token 'else' e 'fimelse' pra executar o resto
        i = @pilhaControle.index('fimelse')
        @pilhaControle[i] = nil
      end
    end

  end

end
