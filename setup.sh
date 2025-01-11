echo 'Setting up configuration\n'
echo '---------------------------\n'
# ---------------------------
# Set working directory
CONFIG_DIR="$HOME/Sources/configurations"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Error: Directory $CONFIG_DIR does not exist"
    exit 1
fi

cd "$CONFIG_DIR" || {
    echo "Error: Failed to change to directory $CONFIG_DIR"
    exit 1
}
echo "Working directory set to: $(pwd)\n"
echo '---------------------------\n'

# ---------------------------
#Get OS type and switch on it and do assignment
case "$OSTYPE" in
  darwin*)  echo 'Mac OS detected';;
  linux*)   echo 'Linux detected';;
  msys*)    echo 'Windows detected';;
  *)        echo 'unknown: OS not supported';;
esac
echo "OS detected: $OSTYPE\n"

# Exit if windows or unknown
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "unknown" ]]; then
    echo "Exiting OS not supported"
    exit 1
fi
echo '---------------------------\n'
# ---------------------------
#Install dependencies
echo "Installing dependencies\n"

#install Kitty terminal
if ! [ -x "$(command -v kitty)" ]; then
    echo 'Installing kitty...' 
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    echo 'Done\n'
else
    echo 'Kitty - already installed'
fi


#Starship
if ! [ -x "$(command -v starship)" ]; then
    echo 'Installing starship...' 
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    echo 'Done\n'
else
    echo 'Starship - already installed'
fi

echo '\n---------------------------\n'

# ---------------------------
# Configure OS specific settings

#handle Mac case
if [[ "$OSTYPE" == darwin* ]]; then
    echo "Setting up Mac configuration\n"
    if ! [ -x "$(command -v brew)" ]; then
        echo 'Installing brew...' 
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'Done\n'
    else
        echo 'Brew - already installed'
    fi
    echo "Creating symlinks for $OSTYPE... "
    if [ -f ~/.bash_profile ]; then
        echo "Backing up existing .bash_profile to .bash_profile.bak"
        mv ~/.bash_profile ~/.bash_profile.bak
    fi
    echo "Creating symlinks for mac"
    ln -sf $CONFIG_DIR/bash/bash_macos ~/.bash_macos
    ln -sf $CONFIG_DIR/bash/bashrc ~/.bash_profile
    echo 'Done'
elif [[ "$OSTYPE" == linux* ]]; then
    echo "Setting up Linux configuration\n"
    if [ -f ~/.bashrc ]; then
        echo "Backing up existing .bashrc to .bashrc.bak"
        mv ~/.bashrc ~/.bashrc.bak
    fi
    echo "Creating symlinks for linux"
    ln -sf $CONFIG_DIR/bash/bash_linux ~/.bash_linux
    ln -sf $CONFIG_DIR/bash/bashrc ~/.bashrc

    echo 'Done'
fi

echo '\n---------------------------\n'

# Create git config
if [ -f ~/.gitconfig ]; then
    echo "Skipping Git configuration setup. Git config already exists"
else
    # Read user input
    echo "Setting up Git configuration"

    echo -n "Enter your Git email address: "
    read -r GIT_EMAIL

    echo -n "Enter your Git username: "
    read -r GIT_USERNAME

    if [ -f ~/.gitconfig ]; then
        echo "Backing up existing .gitconfig to .gitconfig.bak"
        mv ~/.gitconfig ~/.gitconfig.bak
    fi

    # Create gitconfig with user input
    cat > $CONFIG_DIR/git/gitconfig << EOF
[user]
    email = ${GIT_EMAIL}
    name = ${GIT_USERNAME}
[core]
    editor = code
    excludesfile = ~/.gitignore_global
[color]
    ui = auto
EOF

    ln -sf $CONFIG_DIR/git/gitignore_global ~/.gitignore_global
    ln -sf $CONFIG_DIR/git/gitconfig ~/.gitconfig
fi

echo 'Git configuration - Done'

echo '\n---------------------------\n'

# ---------------------------
# Git completion
echo 'Setting up Git completion\n'
if ! [ -f ~/.git-completion.bash ]; then
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -so ~/.git-completion.bash
    echo 'Done'
else
    echo 'Git completion - Nothing to do'
fi

echo 'Git completion - Done'

echo '\n---------------------------\n'

# ---------------------------
# Setup bash aliases
# Depends on git completion installed first
echo 'Setting up bash aliases\n'
if [ -f ~/.bash_aliases ]; then
    echo "Backing up existing .bash_aliases to .bash_aliases.bak"
    mv ~/.bash_aliases ~/.bash_aliases.bak
fi
ln -sf $CONFIG_DIR/bash/bash_aliases ~/.bash_aliases

echo 'Bash aliases - Done'
echo '\n---------------------------\n'
# ---------------------------
#Sourcing current bash
echo 'Sourcing current bash\n'
if [[ "$OSTYPE" == darwin* ]]; then
    source ~/.bash_profile
elif [[ "$OSTYPE" == linux* ]]; then
    source ~/.bashrc
fi
echo 'Source bash Done'

echo '\n---------------------------\n'

echo 'Configuration setup complete\n'
