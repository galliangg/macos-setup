# Managed by Ansible!
#
# Add Colour
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
#
# Add Homebrew sbin directory to $PATH
export PATH="/usr/local/sbin:$PATH"
#
# Add bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
# Have Large History
HISTFILESIZE=10000000
# Avoid succesive duplicates in the bash command history.
HISTCONTROL=ignoredups:erasedups
# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend
# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
#
