# this file is run whenever a new terminal is opened (e.g., new screen tab)
# It should contain things that must be rerun every time a shell is opened

# Options ive read through:
# zshoptions: Change Directories, History, Input/Output

#================
#  COMPLETION
#===============
# not sure what this does, but it is needed for git completion
# Note: some git completion is horribly slow at the root of a large project
autoload -U compinit
compinit

# prevent git from completing file names, which is unbearably slow
# http://www.zsh.org/mla/users/2010/msg00435.html
__git_files(){ _main_complete _files }

# cache results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ignore completion functions for commands you don’t have
zstyle ':completion:*:functions' ignored-patterns '_*'

# allow extended globbing, e.g. opposite ^*.txt, OR (foo|bar)*.txt, recursive **/*.txt
setopt extended_glob

# quick change dirs (type ... and it turns into ../..)
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
# bindkey . rationalise-dot

# pip zsh completion
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

#=========
#  CHANGE DIRECTORIES
#=========
# type the name of a directory to cd to it (if it's not a valid command)
setopt AUTO_CD
# resolve symbolic links when changing directory
setopt CHASE_LINKS

#==========
#  HISTORY
#==========
# - multiple shells retain the same history (hell YES)
# - to access other shell's history, must press enter in already running shell
# - set INC_APPEND_HISTORY to require manual history import into already running
# shell
setopt SHARE_HISTORY
# save timestamps, use history -f to get date and time
setopt EXTENDED_HISTORY
# do not save consecutive repeated commands
setopt HIST_IGNORE_DUPS
# dont find items that were already found when reverse-searching history
setopt HIST_FIND_NO_DUPS
# oldest duplicates expire first
setopt HIST_EXPIRE_DUPS_FIRST
# dont store the history command in history
setopt HIST_NO_STORE
# remove superfluous blanks from history
setopt HIST_REDUCE_BLANKS
# lines to keep in in-memory history; also this many lines will be copied
# from HISTFILE into memory at start of session, so may want to reduce this
# later.
# NOTE: must have SAVEHIST <= HISTSIZE, for unspecified reasons
# http://zsh.sourceforge.net/Guide/zshguide02.html#l7
HISTSIZE=999999999999999999
# number of lines to save in HISTFILE
SAVEHIST=999999999999999999
HISTFILE=~/.history

#=============
# INPUT/OUTPUT
#=============
# must use !> to clobber with redirection or >>! to create new file with append
unsetopt CLOBBER

#==========
#  Zle
#==========
unsetopt BEEP

#=============
#  JOB CONTROL
#=============
# don't send HUP signal to running jobs when shell exits
setopt NOHUP
# don't run background jobs at lower priority
setopt NO_BG_NICE

#==========
#  Prompt
#==========
# Initialize colors.
autoload -U colors
colors

PROMPT="%{$fg[cyan]%}%n@%m%{$reset_color%}" # blue name@
PROMPT+=" %{$fg[green]%}%20<..<%~%{$reset_color%}" # green pwd (truncated to 20 chars)
PROMPT+="%{$fg[red]%}%(?..(%?%))%{$reset_color%}: " # red exit status if nonzero

#============
#  Git Prompt
#============
# see http://sebastiancelis.com/2009/nov/16/zsh-prompt-git-users/
# Basically, run git status and parse the output after
# 1. Changing dirs into a git repo from outside of it
# 2. After running a command that begins with 'git'
# Then use the parsed status to update the RPROMPT

# Changes I made:
# - Git status is only run when entering a git repo, not whenever you change
# directories.
# - Tree is only classified as dirty if there are changes in the staging
# area, untracked files don't count (since I often have these lying around)
# - When you are ahead or behind a branch, the number of commits is
# displayed.

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# Set the prompt.
RPROMPT=$'%{${fg[cyan]}%}$(prompt_git_info)%{${fg[default]}%}'

#=========
#  PATHS
#=========
export EC2_HOME=~/.ec2
if [ -d $EC2_HOME ]; then
    export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
    export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
fi
export JAVA_HOME=$(/usr/libexec/java_home)

export NPM_PACKAGES=~/.npm-packages
export NODE_PATH=$NPM_PACKAGES/lib/node_modules:$NODE_PATH

# prevents repeat elements from being added to path
typeset -U path

export PYENV_ROOT=~/.pyenv

path=($PYENV_ROOT/bin $PYENV_ROOT/shims ~/bin ~/.rvm/bin /usr/local/opt/mysql51/bin /Users/jeremy/bin/android-sdk-macosx/platform-tools /Users/jeremy/bin/android-sdk-macosx/tools ~/.cabal/bin /Applications/ghc-7.8.2.app/Contents/bin /usr/local/Cellar/go/1.2/libexec/bin /usr/texbin $NPM_PACKAGES/bin /usr/local/opt/coreutils/libexec/gnubin /usr/local/opt/postgresql@9.4/bin /usr/local/opt/ruby/bin ~/.gem/ruby/1.8/bin $EC2_HOME/bin /usr/local/bin /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin $path .)

# export PYTHONPATH=$HOME/python-packages:/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# set INFOPATH for emacs info file reading
export INFOPATH=$HOME/info:/usr/share/info:/usr/lib/info:/opt/local/share/info

export EDITOR='emacsclient'

#=========
#  ALIASES
#=========
alias Emacs='/Applications/Emacs.app/Contents/MacOS/Emacs &'
alias ll='ls -alrth --color'
alias codequality='flake8'
alias cq='flake8'
alias ipy='ipython'
alias tree='tree -C'
alias grep='grep --color=yes'
alias ack='ack --color --group'
alias less='less -R'
alias ls='ls -FGa --color'
alias gtc='git checkout'
alias gtm='git checkout master && git pull'
alias gts='git status'
alias gtd='git diff'
alias gtb='git branch'
alias grh='git reset head'
alias gbd='git branch-by-date | head'
gtcb() { git checkout -b "$@"; git push -u origin "$@"; }
repo-name() {
  basename `git rev-parse --show-toplevel`;
}
alias curbranch='git rev-parse --abbrev-ref HEAD'
alias page='LESSOPEN="|pygmentize -g %s" less'
alias ec='screen -X select Emacs && emacsclient -n'

#=============
#  MISC
#=============
export PGUSER=postgres

# make the colors displayed by ls be more visible against a dark background
eval `dircolors ~/.dir_colors`

#==========
#  AUTOJUMP
#==========
#autojump
#Copyright Joel Schaerer 2008, 2009
#This file is part of autojump

#autojump is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#autojump is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with autojump.  If not, see <http://www.gnu.org/licenses/>.

#local data_dir=${XDG_DATA_HOME:-$([ -e ~/.local/share ] && echo ~/.local/share || echo ~)}
local data_dir=$([ -e ~/.local/share ] && echo ~/.local/share || echo ~)
if [[ "$data_dir" = "${HOME}" ]]
then
    export AUTOJUMP_DATA_DIR=${data_dir}
else
    export AUTOJUMP_DATA_DIR=${data_dir}/autojump
fi
if [ ! -e "${AUTOJUMP_DATA_DIR}" ]
then
    mkdir "${AUTOJUMP_DATA_DIR}"
    mv ~/.autojump_py "${AUTOJUMP_DATA_DIR}/autojump_py" 2>>/dev/null #migration
    mv ~/.autojump_py.bak "${AUTOJUMP_DATA_DIR}/autojump_py.bak" 2>>/dev/null
    mv ~/.autojump_errors "${AUTOJUMP_DATA_DIR}/autojump_errors" 2>>/dev/null
fi

function autojump_preexec() {
    { (autojump -a "$(pwd -P)"&)>/dev/null 2>>|${AUTOJUMP_DATA_DIR}/autojump_errors ; } 2>/dev/null
}

typeset -ga preexec_functions
preexec_functions+=autojump_preexec

alias jumpstat="autojump --stat"

function j { local new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }

[[ -s /home/jeremy/.autojump/etc/profile.d/autojump.sh ]] && source /home/jeremy/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u
