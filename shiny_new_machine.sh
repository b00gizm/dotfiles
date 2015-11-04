### Xcode Command Line Tools

# thx  https://github.com/alrra/dotfiles/blob/c2da74cc333/os/os_x/install_applications.sh#L39
if [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; then
    xcode-select --install &> /dev/null
    # Wait until the Xcode Command Line Tools are installed
    while [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; do
        sleep 5
    done
	xcode-select -p &> /dev/null
	if [ $? -eq 0 ]; then
        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10
       sudo xcodebuild -license
   fi
fi

### oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


### Homebrew & Cask

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask

# Add support for Brewfiles
brew tap Homebrew/bundle

# Install ALL THE THINGS!
brew update
brew bundle --file=brew/Brewfile
brew cleanup


### Common Tools

# nvm - Node Version Manager
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.26.1/install.sh | bash

# github.com/jamiew/git-friendly
curl https://raw.github.com/jamiew/git-friendly/master/install.sh | bash

# github.com/paulirish/git-open
npm install -g git-open

# github.com/rupa/z
git clone https://github.com/rupa/z.git ~/Code/z
chmod +x ~/Code/z/z.sh

# Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=${HOME}/.dotfiles/bin --filename=composer

### Set OS X defaults
sh osx/set_defaults.sh


### Symlink files
sh symlink_files.sh
