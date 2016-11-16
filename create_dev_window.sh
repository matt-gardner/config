# Parameters:
# $1 is the directory the window should use (under ~/clone, will also be used as the window name)
# $2, if present, can be "laptop", which will set window sizes for development on a laptop

windowSize=434
if [[ "$2" ]]; then
  if [[ "$2" == "laptop" ]]; then
    windowSize=160
  fi
fi

byobu-tmux new-window -dP -c ~/clone/$1 -k -n $1
byobu-tmux split-window -d -c ~/clone/$1 -h -l $windowSize -t dev:$1 "bash --init-file <(echo '. ~/.bashrc && vim build.sbt')"
byobu-tmux split-window -d -c ~/clone/$1 -l 15 -t dev:${1}.0
