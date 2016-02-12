tmux start-server

# Parameters:
# $1 is the directory the window should use
# $2 is the name of the window
# $3 is the window index
createDevWindow() {
  byobu-tmux new-window -dP -c $1 -k -t $3 -n $2
  byobu-tmux split-window -d -c $1 -h -l 434 -t dev:$2
  byobu-tmux split-window -d -c $1 -l 15 -t dev:${2}.0
}

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

createDevWindow ~/clone/tacl2015-factorization semparse 1
createDevWindow ~/clone/jklol jklol 2
createDevWindow ~/clone/pra pra 3
createDevWindow ~/clone/util util 4

createBlankWindow ~/ misc 5

createWindowWithCommand ~/clone/eclipse eclim 9 "(Xvfb :1 -screen 0 1024x768x24 &);  DISPLAY=:1 ./eclimd"
