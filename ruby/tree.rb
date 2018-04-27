class Tree
    @id = nil
    @children = nil

    def initialize(id, children=[])
        @id = id
        @children = children
        #puts(self)
    end
    
    def leaf?()
        @children.length == 0
    end

    def insert(item)
        if item.is_a?(Tree)
            @children.add(item)

        else
            @children.push(Tree.new(item, []))
        end
    end


    def to_s()
        "<id=#{@id}, children=#{@children}>"
    end
    
        

    def children()
        @children
    end

    def id()
        @id
    end

end

add1 = Tree.new("add", [1, Tree.new("add", [2, 3])])

