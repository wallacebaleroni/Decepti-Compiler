.PHONY: install uninstall

install:
	./install.sh

# testes para a apresentação da P3
fact:
	ruby ./ruby/main.rb

uninstall:
	gem uninstall parslet
	rbenv uninstall 2.5.1
	brew uninstall rbenv