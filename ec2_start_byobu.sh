tmux start-server

windowSize=434
if [[ "$1" ]]; then
  if [[ "$1" == "laptop" ]]; then
    windowSize=160
  fi
fi

echo "Vim window size: $windowSize"

# Parameters:
# $1 is the directory the window should use
# $2 is the name of the window
# $3 is the window index
createDevWindow() {
  if [[ "$4" == "sbt" ]]; then
    byobu-tmux new-window -dP -c $1 -k -t $3 -n $2 "bash --init-file <(echo '. ~/.bashrc && sbt')"
  else
    byobu-tmux new-window -dP -c $1 -k -t $3 -n $2
  fi
  byobu-tmux split-window -d -c $1 -h -l $windowSize -t dev:$2 "vim build.sbt"
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

createDevWindow ~/clone/semparse semparse 1 sbt
createDevWindow ~/clone/pra pra 2 no_sbt
createDevWindow ~/clone/util util 3 no_sbt
#createDevWindow ~/clone/jklol jklol 4 no_sbt

createBlankWindow ~/ misc 5

createWindowWithCommand ~/clone/eclipse eclim 9 "(Xvfb :1 -screen 0 1024x768x24 &);  DISPLAY=:1 ./eclimd"

byobu attach
