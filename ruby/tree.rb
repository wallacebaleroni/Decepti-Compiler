class Tree
    @id = nil
    @children = nil

    # construtor
    def initialize(id, children=[])
        @id = id
        @children = children
    end

    # getters
    def children() @children end
    def id() @id end
    
    # retorna se uma árvore é uma folha ou não
    def leaf?()
        @children.length == 0
    end

    # insere um filho na árvore
    def insert(item)
        if item.is_a?(Tree)
            # se o item já é uma árvore: só insere
            @children.add(item)

        else
            @children.push(Tree.new(item, []))
            # senão: cria árvore/folha desse item e insere
        end
    end

    # representação simples da árvore, para facilitar debug e visualização
    def inspect()
        "<#{@id}, #{@children}>"
    end

    def to_s
        inspect()
    end

end