#!/usr/bin/env bash

set -e

dotfiles=(
  bashrc
  byobu
  gitconfig
  gitignore
  sbt
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
  else
    printf "Trying to install YCM pre-requisites with dnf\n"
    sudo dnf install build-essential cmake python-dev python3-dev
  fi

  printf "Compiling YCM\n"
  cd ~/.vim/bundle/YouCompleteMe
  ./install.py
  cd -
else
  printf "\nLooks like you already installed vundle; skipping vim setup steps\n"
fi

if [ ! -d $HOME/anaconda3 ];
then
  printf "\nInstalling anaconda\n"
  wget https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh
  bash Anaconda3-5.1.0-Linux-x86_64.sh
  rm Anaconda3-5.1.0-Linux-x86_64.sh
else
  printf "\nLooks like you've already installed anaconda3; skipping python setup steps\n"
fi

ec2_scripts=(
  ec2_start_byobu.sh
  create_dev_window.sh
)

if [[ `hostname` == *ai2 ]];
then
  printf "\nSetting up AI2-specific EC2 instance stuff\n"

  printf "\nMoving .bashrc to .bash_user\n"
  mv .bashrc .bash_user

  for script in "${ec2_scripts[@]}"
  do
    printf "Linking $script with: ln -sf $HOME/clone/config/$script\n"
    ln -sf $HOME/clone/config/$script
  done

  printf "\nInstalling some EC2-specific packages\n"
  sudo apt-get install nfs-client

  printf "\nAdding the EFS volume to /etc/fstab (and mounting it now)\n"
  sudo sh -c "echo us-west-2b.fs-07679aae.efs.us-west-2.amazonaws.com:/ /efs nfs4 nfsvers=4.1 >> /etc/fstab"
  sudo mount us-west-2b.fs-07679aae.efs.us-west-2.amazonaws.com:/ /efs -t nfs4

else
  printf "\nNot an AI2 EC2 instance; skipping EC2-specific stuff\n"
fi

printf "TODO: set up eclim\n"
