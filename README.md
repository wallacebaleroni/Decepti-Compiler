

![alt text](https://github.com/wallacebaleroni/Ruby-on-IMP/blob/P1/img/logo.png?raw=true)

Compilador utilizando Ruby e a Gem [Parslet (PEG Parser Generator for Ruby)](http://kschiess.github.io/parslet/) para a linguagem [IMP](https://github.com/ChristianoBraga/BPLC/tree/master/examples/imp).

Compilador para a linguagem [IMP](https://github.com/ChristianoBraga/BPLC/tree/master/examples/imp) escrito em Ruby, utilizando o [Parslet](http://kschiess.github.io/parslet/), uma biblioteca para construir parsers seguindo o modelo PEG (Parsing Expression Grammar).

Trabalho em grupo feito para a matéria de Compiladores, por [Raffael Paranhos](https://github.com/rmparanhos), [Wallace Baleroni](https://github.com/wallacebaleroni) e [Júlia Falcão](https://github.com/juliafalcao).

# Pré-requisitos
É necessário ter a linguagem Ruby e o Parslet instalados.

## macOS
O sistema vem com a linguagem instalada, mas devido às permissões e limitações que impedem o uso de gems, para usar o Parslet é mais fácil instalar uma versão separada do Ruby.

Usando o Homebrew:
```
brew update
brew install ruby
```

Também é possível [baixar](https://www.ruby-lang.org/en/downloads/) direto o código-fonte e compilar:
```
./configure
make
sudo make install
```

Para instalar o Parslet, basta executar o seguinte comando:
```
gem install parslet
```

## Windows
É possível instalar o Ruby no Windows através do [RubyInstaller](https://rubyinstaller.org/).
Depois disso, para instalar o Parslet, abra  linha de comando (```cmd.exe```) e execute:
```
gem install parslet
```
