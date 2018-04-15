# shell script to install the ruby language and the parslet library

brew update
brew install ruby

gem update --system
gem install parslet # 1st draft; might not work because of permissions