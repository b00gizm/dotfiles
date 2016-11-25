#!/usr/bin/env bash

### Helpers
print_header() {
  echo "   _____ __    _                _   __                __  ___           __    _          "
  echo "  / ___// /_  (_)___  __  __   / | / /__ _      __   /  |/  /___ ______/ /_  (_)___  ___ "
  echo "  \__ \/ __ \/ / __ \/ / / /  /  |/ / _ \ | /| / /  / /|_/ / __ \`/ ___/ __ \/ / __ \/ _ \\"
  echo " ___/ / / / / / / / / /_/ /  / /|  /  __/ |/ |/ /  / /  / / /_/ / /__/ / / / / / / /  __/"
  echo "/____/_/ /_/_/_/ /_/\__, /  /_/ |_/\___/|__/|__/  /_/  /_/\__,_/\___/_/ /_/_/_/ /_/\___/ "
  echo "                   /____/                                                                "
  
  print_info "💻  WELCOME TO YOUR BRAND NEW MAC! LET ME SET IT UP FOR YOU…"
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_warning() {
    # Print output in yellow
    printf "\e[0;33m  [!] $1\e[0m\n"
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

print_header

### Clone this repo
print_info "Step #1 - Cloning to $HOME/.dotfiles…"
git clone https://github.com/b00giZm/dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles

### Xcode Command Line Tools
print_info "Step #2 - Installing Xcode command line tools…"

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
print_info "Step #3 - Installing oh-my-zsh…"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


### Neovim stuff
print_info "Step #4 - Cloning neovim-config to $HOME/.config/nvim…"
git clone https://github.com/b00giZm/neovim-config $HOME/.config/nvim


### Homebrew & Cask
print_info "Step #5 - Installing Homebrew and all formulars from $(pwd)/brew/Brewfile…"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask

# Add support for Brewfiles
brew tap Homebrew/bundle

# Install ALL THE THINGS!
brew update
brew bundle --file=brew/Brewfile
brew cleanup


### Common Tools
print_info "Step #6 - Installing common tools…"

# github.com/jiahaog/nativefier
npm install nativefier -g

# github.com/jamiew/git-friendly
curl https://raw.github.com/jamiew/git-friendly/master/install.sh | bash

# github.com/paulirish/git-open
npm install -g git-open

# github.com/rupa/z
git clone https://github.com/rupa/z.git $HOME/Code/z
chmod +x $HOME/Code/z/z.sh

### Set OS X defaults
print_info "Step #7 - Setting macOS defaults…"
sh ./macos/set_defaults.sh


### Symlink files
print_info "Step #8 - Symlinking files…"
sh ./symlink_files.sh


### Print success message
print_success "YAY! Your new Mac is ready!"

if [ ! -f $HOME/.dotfiles/exports.local ]; then
  print_warning "File $HOME/.dotfiles/exports.local not found. You should provide one."
fi