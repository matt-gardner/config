#!/usr/bin/env bash

set -e

dotfiles=(
  bashrc
  byobu
  gitconfig
  gitignore
  shrc
  toprc
  vim
  vimrc
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

if hash apt-get 2>/dev/null; then
  echo "Trying to install cmake and python-dev with: sudo apt-get install cmake python-dev"
  sudo apt-get install -y cmake python-dev
else
  echo "Trying to install cmake and python-dev with: sudo dnf install cmake python-dev"
  sudo dnf install cmake python-dev
fi

echo "Compiling YCM"
cd ~/.vim/bundle/YouCompleteMe
./install.py
cd -

echo "TODO: set up eclim"
echo "TODO: set up sbt plugins (or add some of .sbt to the dotfiles)"
