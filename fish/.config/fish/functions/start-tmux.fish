# start tmux session for work
# this isn't in the actual config because I might want to use tmux for other
# things
function start-tmux
    tmux kill-session
    tmux new-session -d -s spellbook -n "yarn dev" -c work/spellbook
    tmux new-window -t spellbook -n "fish" -c work/spellbook
    tmux send-keys -t spellbook:0 'gt sync; yarn dev' C-m
    tmux attach -t spellbook:1
end
