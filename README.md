![alt text](https://github.com/wallacebaleroni/Ruby-on-IMP/blob/P1/img/logo.png?raw=true)

Compilador utilizando Ruby e a Gem [Parslet (PEG Parser Generator for Ruby)](http://kschiess.github.io/parslet/) para a linguagem [IMP](https://github.com/ChristianoBraga/BPLC/tree/master/examples/imp).

Compilador para a linguagem [IMP](https://github.com/ChristianoBraga/BPLC/tree/master/examples/imp) escrito em Ruby, utilizando o [Parslet](http://kschiess.github.io/parslet/), uma biblioteca para construir parsers seguindo o modelo PEG (Parsing Expression Grammar).

Trabalho em grupo feito para a matéria de Compiladores, por [Júlia Falcão](https://github.com/juliafalcao), [Raffael Paranhos](https://github.com/rmparanhos) e [Wallace Baleroni](https://github.com/wallacebaleroni).

# Pré-requisitos
É necessário ter a linguagem Ruby e o Parslet instalados.

## macOS
O sistema possui uma versão nativa da linguagem já instalada, mas essa versão tem limitações nas permissões que dificultam o uso de gems como o Parslet. É indicado instalar uma versão separada, e ainda assim podem ocorrer erros ao tentar instalar gems se o sistema tentar acessar a versão nativa, então indicamos também o uso de um gerenciador de versões como o [rbenv](https://github.com/rbenv/rbenv). Aqui ensinamos a instalar desse modo, que é mais seguro para evitar erros:

**1.** Usando o Homebrew para instalar o rbenv:

```
brew update
brew install rbenv
```

**2.** Instalando alguma versão do Ruby com o rbenv:
```
eval "$(rbenv init -)"
rbenv install 2.5.1
rbenv rehash
rbenv global 2.5.1
```
O último comando seta a versão que você acabou de instalar como global, evitando que o próximo passo tente instalar a gem na versão nativa do Ruby no sistema.

**3.** Instalando o Parslet:
```
gem install parslet
```

Se você não quiser usar o Homebrew e o rbenv, outras maneiras de instalar Ruby estão explicadas [na documentação oficial](https://www.ruby-lang.org/pt/documentation/installation/), e para instalar o Parslet, o 3º passo acima é o mesmo.

## Windows
É possível instalar o Ruby no Windows através do [RubyInstaller](https://rubyinstaller.org/).
Depois disso, para instalar o Parslet, abra  linha de comando (```cmd.exe```) e execute:
```
gem install parslet
```
