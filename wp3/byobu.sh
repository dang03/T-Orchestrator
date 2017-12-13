#!/bin/bash
SESSION='tnova'

# -2: forces 256 colors, 
byobu-tmux -2 new-session -d -s $SESSION

# dev window
byobu-tmux rename-window -t $SESSION:0 'Mgt'
byobu-tmux send-keys "cd orchestrator_ns-manager" C-m
byobu-tmux send-keys "rake start" C-m

byobu-tmux new-window -t $SESSION:1 -n 'Catlg'
byobu-tmux send-keys "cd orchestrator_ns-catalogue" C-m
byobu-tmux send-keys "rake start" C-m

byobu-tmux new-window -t $SESSION:2 -n 'NSDV'
byobu-tmux send-keys "cd orchestrator_nsd-validator" C-m
byobu-tmux send-keys "rake start" C-m

byobu-tmux new-window -t $SESSION:3 -n 'Prov.'
byobu-tmux send-keys "cd orchestrator_ns-provisioner" C-m
byobu-tmux send-keys "rake start" C-m

byobu-tmux new-window -t $SESSION:4 -n 'Ins.Repo'
byobu-tmux send-keys "cd orchestrator_ns-instance-repository" C-m
byobu-tmux send-keys "rake start" C-m

byobu-tmux new-window -t $SESSION:5 -n 'NSMon'
byobu-tmux send-keys "cd orchestrator_ns-monitoring" C-m
byobu-tmux send-keys "rake start" C-m

byobu-tmux new-window -t $SESSION:6 -n 'NSMon.Repo'
byobu-tmux send-keys "cd orchestrator_ns-monitoring-repository" C-m
byobu-tmux send-keys "rake start" C-m


# Set default window as the dev split plane
byobu-tmux select-window -t $SESSION:0

