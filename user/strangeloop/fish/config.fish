
# hide help greeting
set -g fish_greeting
# use vi bindings
fish_vi_key_bindings

# create or attach to "session"
#if not [ $TMUX ]
#  tmux new -As DEFAULT
#end

# use LS_COLORS
export LS_COLORS="*.*=0"
#eval (dircolors -c ~/.config/LS_COLORS)

# set variables
set -gx EDITOR nvim
set -gx VISUAL nvim
