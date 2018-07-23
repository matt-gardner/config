function set_status {
  TEXT=$1
  EMOJI=$2
  STATUS_JSON="{\"status_text\": \"$TEXT\", \"status_emoji\": \"$EMOJI\"}"
  curl -s -d "payload=$json"  --data-urlencode "token=$SLACK_TOKEN" \
    --data-urlencode "profile=$STATUS_JSON" \
    https://slack.com/api/users.profile.set >/dev/null
}

function clear_status {
  set_status "" ""
}

MINUTES=$1
if [ -z "$MINUTES" ]; then
  echo "Usage: pomodoro MINUTES"
  exit -1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  END_TIME=`date -v "+${MINUTES}M" "+%-I:%M %p"`
else
  END_TIME=`date -d "+${MINUTES} minutes" "+%-I:%M %p"`
fi

set_status "Focused work until $END_TIME" ":tomato:"

pomodoro_binary $MINUTES

clear_status
