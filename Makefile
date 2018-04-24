.PHONY: install uninstall

install:
	./install.sh

uninstall:
	gem uninstall parslet
	rbenv uninstall 2.5.1
	brew uninstall rbenv