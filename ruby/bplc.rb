require_relative 'smc'
require_relative 'tree'

class Bindable
  @id = nil # "loc" (var decl) / "value" (const decl) / "proc" (procedure decl)
  @content = nil # memory address (var decl) / constant variable (const decl) / procedure decls & cmds

  def initialize(id, content)
    @id = id
    @content = content
  end

  def content()
    @content
  end

  def setContent(content)
    @content = content
  end

  def id()
    @id
  end

  def inspect()
    "(#{@id}, #{@content})"
  end

  def to_s()
    inspect()
  end

  def is_loc?()
    @id == "loc"
  end

end

class Callables
  @id = nil #"proc" (procedure decl)
  @formals = nil #parametros
  @content = nil #procedure decls & cmds

  def initialize(id, formals, content)
    @id = id
    @formals = formals
    @content = content
  end


  def formals()
    @formals
  end

  def content()
    @content
  end

  def setContent(content)
    @content = content
  end

  def id()
    @id
  end

  def inspect()
    "(#{@id},#{@formals}, #{@content})"
  end

  def to_s()
    inspect()
  end

end

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
        when "prc"
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

        when "const_seq"
          self.const_seq(val)

        when "const"
          self.const(val)

        when "block"
          self.block(val)

        when "block_ret"
          self.block_ret(val)

        when "blockend"
          self.blockend(val)

        when "cmd"
          self.cmd(val)

        when "cal"
          self.call(val)

        when "fun"
          self.fun(val)

        when "module"
          self.module(val)

      else
          if is_integer?(val.id)
            self.num(val)
          
          else
            self.access(val)
          end

      end

      # Imprime o SMC
      $smc.print_smc()
    end
  end

  # Mark 1

  def block(val)
    # Tira o block da pilha de controle
    $smc.popC()

    # Coloca o decl_seq e o cmd na pilha de controle
    decl_seq = val.children.shift()
    cmd = val.children.shift()
    if not cmd.nil?
      $smc.pushC(cmd)
    end
    if not decl_seq.nil?
      $smc.pushC(decl_seq)
    end
  end

  def block_ret(val)
    # Tira o block da pilha de controle
    $smc.popC()

    # Coloca o decl_seq e o cmd na pilha de controle
    ret = val.children.shift()
    decl_seq = val.children.shift()
    cmd = val.children.shift()
    $smc.pushC(cmd)
    $smc.pushC(decl_seq)
    $smc.pushC(ret)

  end

  def cmd(val)
    $smc.popC() # tira o cmd da pilha de controle
    command = val.children.shift() # seq, while, if etc.
    $smc.pushC(command)

  end

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
          bindable = Bindable.new("loc", nil)
          $smc.writeE(var, bindable)
          $smc.writeM(var, value.id)
          $smc.writeA(var)

        else
          $smc.pushC(value)
        end

      else
        $smc.pushS(val.children[0])
        val.children.shift()
    end
  end

  def const_seq(val)
    # Se for o último filho já pode tirar o var_seq da pilha de controle
    if val.children.length == 1
      $smc.popC()
    end

    # Vê se o filho é ini_seq ou ini
    child = val.children.shift()
    case child.id
      when "ini_seq"
        child = Tree.new((Parslet::Slice.new(0, "const_seq")), child.children)
      when "ini"
        child = Tree.new((Parslet::Slice.new(0, "const")), child.children)
    end

    # Reempilha filho na pilha de controle
    $smc.pushC(child)
  end

  def const(val)
    case val.children.length
      when 0
        value = $smc.popS()
        if is_integer?(value.id)
          $smc.popC()
          var = $smc.popS().str
          bindable = Bindable.new("value", value.id) # ?
          $smc.writeE(var, bindable) # !!
          # $smc.writeM(var,value.id)
          $smc.writeA(var)
        
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
        puts()
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
          $smc.pushA
          $smc.pushC(Tree.new("blockend",[]))
          $smc.pushC(bif)
        else
          if not belse.nil?
            $smc.pushA
            $smc.pushC(Tree.new("blockend",[]))
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
        left = left.id.to_i()
        right = right.id.to_i()
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
        left = left.id.to_i()
        right = right.id.to_i()
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
        left = left.id.to_i()
        right = right.id.to_i()
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
        left = left.id.to_i()
        right = right.id.to_i()
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
        if left.id.to_i() == right.id.to_i()
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
        if right.id.to_i() < left.id.to_i()
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
        if right.id.to_i() <= left.id.to_i()
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
        if right.id.to_i() > left.id.to_i()
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
        if right.id.to_i() >= left.id.to_i()
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
          $smc.pushA
          $smc.pushC(Tree.new("blockend",[]))
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

  def num(val)
    $smc.popC()
    $smc.pushS(val)
  end

  def pproc(val)
    $smc.popC()
    #var = $smc.popS().str
    callable = Callables.new("proc", val.children[1],val.children[2])
    $smc.writeECallable(val.children[0].id.str, callable)
    #$smc.writeM(var, value.id)
    $smc.writeA(val.children[0].id.str)
  end

  def fun(val)
    $smc.popC()
    #var = $smc.popS().str
    callable = Callables.new("func", val.children[1],val.children[2])
    $smc.writeECallable(val.children[0].id.str, callable)
    #$smc.writeM(var, value.id)
    $smc.writeA(val.children[0].id.str)
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

          if $smc.const?(var)
            raise "Exception: Cannot assign constant " + var.to_s + "."
          end
          if not $smc.instantiated?(var)
            raise "Exception: Variable " + var.to_s +  " referenced before assignment"
          end
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

  def access(val)
    $smc.popC
    $smc.pushS(Tree.new($smc.readM(val.id.str),))
  end

  def blockend(val)
    $smc.popC
    $smc.popA()
  end

  def call(val)
    $smc.popC
    $smc.pushA
    callable_actuals = val.children[1]
    callable_bl,callable_formals = $smc.readM(val.children[0].id.str)
    puts(callable_formals)
    puts(callable_actuals)

    if(callable_formals != nil)
      if(callable_actuals.is_a? Enumerable)
        i = 0
        for item in callable_actuals
          var = Bindable.new("loc",nil)
          $smc.writeE(callable_formals[i].id.str,var)
          $smc.writeM(callable_formals[i].id.str,item.id)
          $smc.writeA(callable_formals[i].id.str)
          i += 1
        end
      else
        var = Bindable.new("loc",nil)
        $smc.writeE(callable_formals.id.str,var)
        $smc.writeM(callable_formals.id.str,callable_actuals.id)
        $smc.writeA(callable_formals.id.str)
      end
    end
    $smc.pushC(Tree.new("blockend",[]))
    $smc.pushC(callable_bl.deepcopy())
  end

  def module(val)
    $smc.popC
    $smc.pushC(Tree.new("blockend",[]))
    if val.children.length == 3
      for item in val.children[2]
        $smc.pushC(item)
      end

      for item in val.children[1]
        $smc.pushC(item)
      end
    elsif val.children.length == 4
      for item in val.children[3]
        $smc.pushC(item)
      end
      for item in val.children[2]
        $smc.pushC(item)
      end
      puts(val.children[1].children)
      for item in val.children[1].children
        $smc.pushC(item)
      end
    end
    $smc.pushA

  end

end
