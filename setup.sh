echo 'Setting up configuration\n'

# ---------------------------

cd ~/Sources/configurations

printf 'Creating symlinks ... '
# ln -sf ~/Sources/configuration/gitconfig ~/.gitconfig

ln -sf ~/Sources/configurations/bashrc ~/.bash_profile

echo 'Done\n'


chmod +x ./*

echo 'Installing plugins...'
./gitCompletion.sh
# ./tmuxPluginManager.sh
echo 'Done\n'