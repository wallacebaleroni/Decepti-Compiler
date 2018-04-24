# shell script to install the ruby language and the parslet library on macOS

# install rbenv through homebrew
brew update
brew install rbenv

# install ruby 2.5.1 through rbenv
eval "$(rbenv init -)"
rbenv install 2.5.1
rbenv rehash
rbenv global 2.5.1

# install the parslet gem
gem install parslet