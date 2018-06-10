require_relative 'smc'
require_relative 'tree'


class BPLC
  def vamosRodar()
    puts("\nAutobots, let's roll!")

    # Imprime o SMC
    $smc.print_smc()

    while($smc.lengthC > 0)
      # Olha o topo do Controle e vê qual regra se aplica
      val = $smc.topC()
      case val.id
        # Mark 0
        when "proc"
          self.pproc(val)
        when "seq"
          self.seq(val)
        when "assign"
          self.assign(val)
        when "while"
          self.while(val)
        when "neg"
          self.neg(val)
        when "eq"
          self.eq(val)
        when "mul"
          self.mul(val)
        when "div"
          self.div(val)
        when "sub"
          self.sub(val)
        when "add"
          self.add(val)
        when "print"
          self.pprint(val)
        when "lt"
          self.lt(val)
        when "gt"
          self.gt(val)
        when "gteq"
          self.gteq(val)
        when "lteq"
          self.lteq(val)
        when "if"
          self.if(val)
        # Mark 1
        when "decl_seq"
          self.decl_seq(val)
        when "decl"
          self.decl(val)
        when "var_seq"
          self.var_seq(val)
        when "var"
          self.var(val)
        else
          if is_integer?(val.id)
            self.num(val)
          else
            # TODO: olhar isso, ele esperava um identificador aqui, talvez tenha que criar uma regra nova pra esse caso
            self.var(val)
          end
      end

      # Imprime o SMC
      $smc.print_smc()
    end
  end


  # Mark 1
  def decl_seq(val)
    # Tira o decl_seq da pilha de controle
    $smc.popC()

    # Coloca os decl na pilha de controle
    seq1 = val.children.shift()
    seq2 = val.children.shift()
    $smc.pushC(seq2)
    $smc.pushC(seq1)
  end

  def decl(val)
    # Tira o decl da pilha de controle
    $smc.popC()

    tipo = val.children.shift()
    child = val.children.shift()

    # Vê se o tipo é var ou const
    case tipo.str
      when "var"
        # Vê se o filho é ini_seq ou ini
        case child.id
          when "ini_seq"
            child = Tree.new((Parslet::Slice.new(0, "var_seq")), child.children)
          when "ini"
            child = Tree.new((Parslet::Slice.new(0, "var")), child.children)
        end
      when "const"
        # Vê se é ini_seq ou ini
        case child.id
          when "ini_seq"
            child = Tree.new((Parslet::Slice.new(0, "const_seq")), child.children)
          when "ini"
            child = Tree.new((Parslet::Slice.new(0, "const")), child.children)
        end
    end

    # Reempilha filho na pilha de controle
    $smc.pushC(child)
  end

  def var_seq(val)
    # Se for o último filho já pode tirar o var_seq da pilha de controle
    if val.children.length == 1
      $smc.popC()
    end

    # Vê se o filho é ini_seq ou ini
    child = val.children.shift()
    case child.id
      when "ini_seq"
        child = Tree.new((Parslet::Slice.new(0, "var_seq")), child.children)
      when "ini"
        child = Tree.new((Parslet::Slice.new(0, "var")), child.children)
    end

    # Reempilha filho na pilha de controle
    $smc.pushC(child)
  end

  def var(val)
    case val.children.length
      when 0
        value = $smc.popS()
        if is_integer?(value.id)
          $smc.popC()
          var = $smc.popS().str
          $smc.writeE(var)
          $smc.writeM(var,value.id)
        else
          $smc.pushC(value)
        end
      else
        $smc.pushS(val.children[0])
        val.children.shift()
    end
  end

  # Mark 0
  def pprint(val)
    case val.children.length
      when 0
        $smc.popC()
        val = $smc.popS()
        puts(val.id)
      else
        exp = val.children.shift()
        $smc.pushC(exp)
    end
  end


  def if(val)
    case val.children.length
      when 0
        $smc.popC()
        bool = $smc.popS()
        bif = $smc.popS()
        belse = $smc.popS()
        if bool == "true"
          $smc.pushC(bif)
        else
          if not belse.nil?
            $smc.pushC(belse)
          end
        end
      else
        cond = val.children.shift()
        bif = val.children.shift()
        belse = val.children.shift()

        $smc.pushS(belse)
        $smc.pushS(bif)
        $smc.pushC(cond)
    end
  end


  def add(val)
    case val.children.length
      when 0
        $smc.popC()
        left = $smc.popS()
        right = $smc.popS()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (right + left).to_s()
        res = Tree.new((Parslet::Slice.new(0,res)))
        $smc.pushS(res)
      else
        $smc.pushC(val.children[0])
        val.children.shift()
    end
  end


def sub(val)
    case val.children.length
      when 0
        $smc.popC()
        left = $smc.popS()
        right = $smc.popS()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (right - left).to_s()
        res = Tree.new((Parslet::Slice.new(0,res)))
        $smc.pushS(res)
      else
        $smc.pushC(val.children[0])
        val.children.shift()
    end
  end


  def mul(val)
    case val.children.length
      when 0
        $smc.popC()
        left = $smc.popS()
        right = $smc.popS()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (left * right).to_s()
        res = Tree.new((Parslet::Slice.new(0, res)))
        $smc.pushS(res)
      else
        $smc.pushC(val.children[0])
        val.children.shift()
    end
  end

  def div(val)
    case val.children.length
      when 0
        $smc.popC()
        left = $smc.popS()
        right = $smc.popS()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (right / left).to_s()
        res = Tree.new((Parslet::Slice.new(0, res)))
        $smc.pushS(res)
      else
        $smc.pushC(val.children[0])
        val.children.shift()
    end
  end

  def eq(val)
    case val.children.length
      when 0
        $smc.popC()
        left = $smc.popS()
        right = $smc.popS()
        if left.id.str.to_i() == right.id.str.to_i()
          $smc.pushS("true")
        else
          $smc.pushS("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.pushC(left)
        $smc.pushC(right)
    end
  end

  def lt(val)
    case val.children.length
      when 0
        $smc.popC()
        right = $smc.popS()
        left = $smc.popS()
        if right.id.str.to_i() < left.id.str.to_i()
          $smc.pushS("true")
        else
          $smc.pushS("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.pushC(left)
        $smc.pushC(right)
    end
  end

  def lteq(val)
    case val.children.length
      when 0
        $smc.popC()
        right = $smc.popS()
        left = $smc.popS()
        if right.id.str.to_i() <= left.id.str.to_i()
          $smc.pushS("true")
        else
          $smc.pushS("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.pushC(left)
        $smc.pushC(right)
    end
  end

  def gt(val)
    case val.children.length
      when 0
        $smc.popC()
        right = $smc.popS()
        left = $smc.popS()
        if right.id.str.to_i() > left.id.str.to_i()
          $smc.pushS("true")
        else
          $smc.pushS("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.pushC(left)
        $smc.pushC(right)
    end
  end

  def gteq(val)
    case val.children.length
      when 0
        $smc.popC()
        right = $smc.popS()
        left = $smc.popS()
        if right.id.str.to_i() >= left.id.str.to_i()
          $smc.pushS("true")
        else
          $smc.pushS("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.pushC(left)
        $smc.pushC(right)
    end
  end

  def neg(val)
    case val.children.length
      when 0
        $smc.popC()
        bool = $smc.popS()
        case bool
          when "true"
            $smc.pushS("false")
          when "false"
            $smc.pushS("true")
          else
        end
      else
        exp = val.children.shift()
        $smc.pushC(exp)
    end
  end

  def while(val)
    case val.children.length
      when 0
        $smc.popC()
        bool = $smc.popS()
        if bool == "true"
          cond = $smc.popS()
          block = $smc.popS()
          novo_while = Tree.new("while", [cond.deepcopy(), block.deepcopy()])
          $smc.pushC(novo_while)
          $smc.pushC(Tree.new("blockend",[]))
          $smc.pushC(block.deepcopy())
        else
          $smc.popS()
          $smc.popS()
        end
      else
        cond = val.children.shift()
        block = val.children.shift()
        $smc.pushS(block.deepcopy())
        $smc.pushS(cond.deepcopy())
        $smc.pushC(cond.deepcopy())
    end
  end

  def num(val)
    $smc.popC()
    $smc.pushS(val)
  end

  def pproc(val)
    $smc.popC()
    $smc.pushC(val.children[0])
  end

  def seq(val)
    $smc.popC()
    $smc.pushC(val.children[1])
    $smc.pushC(val.children[0])
  end

  def assign(val)
    case val.children.length
      when 0
        value = $smc.popS()
        if is_integer?(value.id)
          $smc.popC()
          var = $smc.popS().id.str
          $smc.writeM(var, value.id.str)
        else
          $smc.pushC(value)
        end
      else
        $smc.pushS(val.children[0])
        val.children.shift()
    end
  end

  def is_integer?(val)
    val.to_i.to_s == val
  end

end
