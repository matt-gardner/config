tmux start-server

laptopArg=""
if [[ "$1" ]]; then
  if [[ "$1" == "laptop" ]]; then
    laptopArg="-l"
  fi
fi

# Parameters:
# $1 is the directory the window should use
# $2 is the name of the window
# $3 is the window index
createBlankWindow() {
  byobu-tmux new-window -dP -c $1 -t $3 -n $2
}

# Parameters:
# $1 is the directory the window should use
# $2 is the name of the window
# $3 is the window index
# $4 is the command to run
createWindowWithCommand() {
  byobu-tmux new-window -dP -c $1 -t $3 -n $2 "$4"
}

byobu-tmux new-session -d -s dev

./create_dev_window.sh -t 1 $laptopArg allennlp

createBlankWindow ~/ misc 8

createWindowWithCommand ~/clone/eclipse eclim 9 "(Xvfb :1 -screen 0 1024x768x24 &);  DISPLAY=:1 ./eclimd"

byobu-keybindings
byobu attach
