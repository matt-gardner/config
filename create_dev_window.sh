# Arguments:
# $1 is the directory the window should use (under ~/clone, will also be used as the window name)
# Options (must come after the argument):
#   -l: for laptop, changes how windows are set up
#   -t [num]: tmux's -t argument - which window should we use?

windowSize=434
windowNumArg=""
useLaptop=false

while getopts "lt:" opt; do
  case $opt in
    l)
      useLaptop=true
      ;;
    t)
      windowNumArg="-t $OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $(expr $OPTIND - 1)

byobu-tmux new-window -dP -c ~/clone/$1 -k -n $1 $windowNumArg
if [ "$useLaptop" ]; then
  byobu-tmux split-window -d -c ~/clone/$1 -h -t dev:$1
  byobu-tmux new-window -dP -c ~/clone/$1 -k -n $1-vim "vim build.sbt"
else
  byobu-tmux split-window -d -c ~/clone/$1 -h -l $windowSize -t dev:$1 "vim build.sbt"
  byobu-tmux split-window -d -c ~/clone/$1 -l 15 -t dev:${1}.0
fi
