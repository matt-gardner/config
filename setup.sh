dotfiles=(
  bashrc
  shrc
  gitconfig
  gitignore
  vim
  vimrc
  byobu
)

for dotfile in "${dotfiles[@]}"
do
  echo "Linking $dotfile with: ln -sf $HOME/clone/config/dotfiles/$dotfile .$dotfile"
  ln -sf $HOME/clone/config/dotfiles/$dotfile .$dotfile
done

echo "Installing vundle with: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing vundle plugins with: vim -c PluginInstall -c quitall"
vim -c PluginInstall -c quitall

echo "Trying to install cmake and python-dev with: sudo apt-get install cmake python-dev"
sudo apt-get install cmake python-dev

echo "Compiling YCM"
cd ~/.vim/bundle/YouCompleteMe
./install.py
cd -
