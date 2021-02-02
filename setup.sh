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
  printf "Linking $dotfile with: ln -sf $HOME/clone/config/dotfiles/$dotfile .$dotfile\n"
  ln -sf $HOME/clone/config/dotfiles/$dotfile .$dotfile
done

if [ ! -d $HOME/.vim/bundle/Vundle.vim ];
then
  printf "\nInstalling vundle with: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim\n"
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

  printf "Installing vundle plugins with: vim -c PluginInstall -c quitall\n"
  vim -c PluginInstall -c quitall

  if hash apt-get 2>/dev/null; then
    printf "Trying to install YCM pre-requisites with apt-get\n"
    sudo apt-get install -y build-essential cmake python-dev python3-dev exuberant-ctags
    printf "Compiling YCM\n"
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py
    cd -
  else
    printf "You need to install pre-requisites for YCM and compile it yourself\n"
  fi

else
  printf "\nLooks like you already installed vundle; skipping vim setup steps\n"
fi

scripts=(
  start_byobu.sh
  create_dev_window.sh
)

for script in "${scripts[@]}"
do
  printf "Linking $script with: ln -sf $HOME/clone/config/$script\n"
  ln -sf $HOME/clone/config/$script
done
