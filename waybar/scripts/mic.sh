#!/usr/bin/env bash

status=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
vol=$(echo "$status" | grep -oP '\d+\.\d+' | awk '{printf "%.0f", $1*100}')

device=$(wpctl status | awk '
  /├─ Sources:/ {found=1; next}
  /├─ Filters:/ {found=0}
  found && /\*/ {
    sub(/^\s*│?\s*\*?\s*[0-9]+\.\s*/, "");
    sub(/\s*\[vol:.*\]\s*$/, "");
    print;
    exit
  }
'
)

if echo "$status" | grep -q "MUTED"; then
  echo "{\"text\": \"󰍭\", \"tooltip\": \"$device\", \"class\": \"muted\"}"
else
  echo "{\"text\": \"󰍬 ${vol}%\", \"tooltip\": \"$device\", \"class\": \"active\"}"
fi

