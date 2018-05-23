require_relative 'smc'
require_relative 'tree'


class BPLC
  def vamosRodar()
    puts("Autobots, let's roll!")

    while($smc.lengthC > 0)
      val = $smc.topC()
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
        when "if"
          self.if(val)
        when "decl_var"
          self.decl_var(val)
          $smc.to_s
        when "var_seq"
          self.var_seq(val)
          $smc.to_s
        when "var"
          self.var_exists(val)
        when "decl"
          self.decl(val)
          $smc.to_s
        else
          if is_integer?(val.id)
            self.num(val)
          else
            self.var(val)
          end
      end
    end
  end


  #mark1

  def var_seq(val)
    case val.children.length
      when 1
        child = val.children.shift()
        case child.id
          when "ini_seq"
            $smc.popC()
            child = Tree.new("var_seq", child.children)
          when "ini"
            $smc.popC()
            child = Tree.new("var", child.children)
        end
        $smc.pushC(child)
      else
        child = val.children.shift()
        case child.id
          when "ini_seq"
            child = Tree.new("var_seq", child.children)
          when "ini"
            child = Tree.new("var", child.children)
        end
        $smc.pushC(child)
    end
  end

  def decl_var(val)
    case val.children.length
      when 1
        child = val.children.shift()
        case child.id
          when "ini_seq"
            $smc.popC()
            child = Tree.new("var_seq", child.children)
          when "ini"
            $smc.popC()
            child = Tree.new("var", child.children)
        end
        $smc.pushC(child)
      else
        child = val.children.shift()
        case child.id
          when "ini_seq"
            child = Tree.new("var_seq", child.children)
          when "ini"
            child = Tree.new("var", child.children)
        end
        $smc.pushC(child)
    end
  end

  def decl(val)
    decl = val.children.shift()
    $smc.popC()
    $smc.pushC(decl)
  end

  def var_exists(val)
    case val.children.length
      when 0
        value = $smc.popS()
        if is_integer?(value.id)
          $smc.popC()
          var = $smc.popS().id.str
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

  #mark 0
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

  def var(val)
    $smc.popC
    var = $smc.readM(val.id.str).to_s
    new_val = Tree.new((Parslet::Slice.new(0, var)))
    $smc.pushS(new_val)
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
