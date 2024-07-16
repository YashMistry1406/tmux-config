#!/bin/bash

 > tmuxrestore.json
tmux list-sessions -F "#{session_name}" | while read -r session; do
    tmux list-windows -t "$session" -F "#{window_index}: #{window_name}" | while read -r window; do
        window_index=$(echo "$window" | cut -d':' -f1)
        window_name=$(echo "$window" | cut -d':' -f2)
        tmux list-panes -t "$session:$window_index" -F "Pane: #{pane_index} - Size: #{pane_width}x#{pane_height} -#{pane_current_path}"  | while read -r pane_width; do
        pane=$(echo "$pane_width" | cut -d'-' -f1 | cut -d':' -f2)
        size=$(echo "$pane_width" | cut -d'-' -f2 | cut -d':' -f2)
        #title=$(echo "$pane_width" | cut -d'-' -f3)
        #command=$(echo "$pane_width" | cut -d'-' -f3)
        path=$(echo "$pane_width" | cut -d '-' -f3)
    json_string=$(
  jq --null-input \
    --arg session "${session}" \
    --arg window_index "${window_index}" \
    --arg window_name "${window_name}" \
    --arg pane "${pane}" \
    --arg size "${size}" \
    --arg path "${path}" \
    '{session: $session, window_index: $window_index, window_name: $window_name, pane: $pane,size: $size , path:$path}'
)
echo $json_string >> tmuxrestore.json
        done
    done
done


## if session exists create windows and panes in existing session 
## else create a new 

