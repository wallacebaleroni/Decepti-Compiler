require_relative 'smc'
require_relative 'tree'


class BPLC
  def vamosRodar(smc)
    puts("Autobots, let's roll!")
    while($smc.tamPilhaControle > 0)
      val = $smc.topoControle()
      case val.id
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
        else
          if is_integer?(val.id)
            self.num(val)
          else
            self.var(val)
          end
      end
    end
  end


  def pprint(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        val = $smc.desempilhaValor()
        puts(val.id)
      else
        exp = val.children.shift()
        $smc.empilhaControle(exp)
    end
  end


  def add(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (right + left).to_s()
        res = Tree.new((Parslet::Slice.new(0,res)))
        $smc.empilhaValor(res)
      else
        $smc.empilhaControle(val.children[0])
        val.children.shift()
    end
  end


def sub(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (right - left).to_s()
        res = Tree.new((Parslet::Slice.new(0,res)))
        $smc.empilhaValor(res)
      else
        $smc.empilhaControle(val.children[0])
        val.children.shift()
    end
  end


  def mul(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (left * right).to_s()
        res = Tree.new((Parslet::Slice.new(0, res)))
        $smc.empilhaValor(res)
      else
        $smc.empilhaControle(val.children[0])
        val.children.shift()
    end
  end

  def div(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        left = left.id.str.to_i()
        right = right.id.str.to_i()
        res = (right / left).to_s()
        res = Tree.new((Parslet::Slice.new(0, res)))
        $smc.empilhaValor(res)
      else
        $smc.empilhaControle(val.children[0])
        val.children.shift()
    end
  end

  def eq(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        if left.id.str.to_i() == right.id.str.to_i()
          $smc.empilhaValor("true")
        else
          $smc.empilhaValor("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.empilhaControle(left)
        $smc.empilhaControle(right)
    end
  end

  def lt(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        if right.id.str.to_i() < left.id.str.to_i()
          $smc.empilhaValor("true")
        else
          $smc.empilhaValor("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.empilhaControle(left)
        $smc.empilhaControle(right)
    end
  end

  def lteq(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        if right.id.str.to_i() <= left.id.str.to_i()
          $smc.empilhaValor("true")
        else
          $smc.empilhaValor("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.empilhaControle(left)
        $smc.empilhaControle(right)
    end
  end

  def gt(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        if right.id.str.to_i() > left.id.str.to_i()
          $smc.empilhaValor("true")
        else
          $smc.empilhaValor("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.empilhaControle(left)
        $smc.empilhaControle(right)
    end
  end

  def gteq(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        left = $smc.desempilhaValor()
        right = $smc.desempilhaValor()
        if right.id.str.to_i() >= left.id.str.to_i()
          $smc.empilhaValor("true")
        else
          $smc.empilhaValor("false")
        end
      else
        left = val.children.shift()
        right = val.children.shift()
        $smc.empilhaControle(left)
        $smc.empilhaControle(right)
    end
  end

  def neg(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        bool = $smc.desempilhaValor()
        case bool
          when "true"
            $smc.empilhaValor("false")
          when "false"
            $smc.empilhaValor("true")
          else
        end
      else
        exp = val.children.shift()
        $smc.empilhaControle(exp)
    end
  end

  def while(val)
    case val.children.length
      when 0
        $smc.desempilhaControle()
        bool = $smc.desempilhaValor()
        if bool == "true"
          cond = $smc.desempilhaValor()
          block = $smc.desempilhaValor()
          novo_while = Tree.new("while", [cond.deepcopy(), block.deepcopy()])
          $smc.empilhaControle(novo_while)
          $smc.empilhaControle(block.deepcopy())
        else
          $smc.desempilhaValor()
          $smc.desempilhaValor()
        end
      else
        cond = val.children.shift()
        block = val.children.shift()
        $smc.empilhaValor(block.deepcopy())
        $smc.empilhaValor(cond.deepcopy())
        $smc.empilhaControle(cond.deepcopy())
    end
  end

  def var(val)
    $smc.desempilhaControle
    var = $smc.acessaMemoria(val.id.str).to_s
    new_val = Tree.new((Parslet::Slice.new(0, var)))
    $smc.empilhaValor(new_val)
  end

  def num(val)
    $smc.desempilhaControle()
    $smc.empilhaValor(val)
  end

  def pproc(val)
    $smc.desempilhaControle()
    $smc.empilhaControle(val.children[0])
  end

  def seq(val)
    $smc.desempilhaControle()
    $smc.empilhaControle(val.children[1])
    $smc.empilhaControle(val.children[0])
  end

  def assign(val)
    case val.children.length
      when 0
        value = $smc.desempilhaValor()
        if is_integer?(value.id)
          $smc.desempilhaControle()
          var = $smc.desempilhaValor().id.str
          $smc.escreveMemoria(var, value.id.str)
        else
          $smc.empilhaControle(value)
        end
      else
        $smc.empilhaValor(val.children[0])
        val.children.shift()
    end
  end

  def is_integer?(val)
    val.to_i.to_s == val
  end
end
