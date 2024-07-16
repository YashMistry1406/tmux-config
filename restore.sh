#!/bin/bash


flag=-1
cat tmuxrestore.json | while read -r line; do 
session_name=$(echo "$line" | jq -r '.session')
window_index=$(echo "$line" | jq -r '.window_index')
window_name=$(echo "$line" | jq -r '.window_name')
pane=$(echo "$line" | jq -r '.pane' |  sed 's/[[:blank:]]//g')
size=$(echo "$line" | jq -r '.size')
#tittle=$(echo "$line" | jq -r '.tittle')
#command=$(echo "$line" | jq -r '.command')
path=$(echo "$line" | jq -r '.path' | cut -d'~' -f2)

tmux has-session -t $session_name 2>/dev/null

if [ $? != 0 ]; then 
    tmux new-session -d -s "$session_name" -c "$path"
fi
if [ $window_index -eq 0 ]; then 
    tmux rename-window "$window_name"
    continue
fi
tmux new-window -t $session_name:$window_index -n $window_name -c "$path"
done 

tmux select-window -t $session_name:0


