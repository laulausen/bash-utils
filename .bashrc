# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export BASH_HOME="$HOME"
export BASH_USER="GOD"
export BASH_HOST="HEAVEN"
#########################################################
# ######### Dirs to check and export ################## #
#########################################################
export ANDROID_DIR=$BASH_HOME/Android                   #
export SDK=$ANDROID_DIR/Sdk                             #
#               SCRIPTS to IMPORT                       #
export BASHSRC=$BASH_HOME/.bashsrc                      #
#                                                       #
#             ENV_SETS FOR RUNNING                      #
export BASH_ENVS=$BASH_HOME/.bash_envs                  #
#                                                       #
#                   PATHES                              #
export BASH_BIN=$BASH_HOME/bin                          #
export BASH_SBIN=$BASH_HOME/.sbin                       #
export PLATFORM_TOOLS=$SDK/platform-tools               #
export CMD_LINE_TOOLS=$SDK/cmdline-tools/latest/bin     #
export AOSP_HOST_TOOLS=$BASH_SBIN/aosp_host_tools       #
export CMAKE=$SDK/cmake/3.22.1/bin                      #
export BUILD_TOOLS=$SDK/build-tools/35.0.0              #
#########################################################
export BASH_PATHES=( BASH_BIN BASH_SBIN PLATFORM_TOOLS AOSP_HOST_TOOLS CMD_LINE_TOOLS CMAKE BUILD_TOOLS )
#########################################################

export TAG="ENV"
export logging=$BASHSRC/fun_log
[ -e "$logging" ] && . $logging
OLD_LEVEL=$LOG_LEVEL
export LOG_LEVEL="DEBUG"
#########################################################
cd $BASH_HOME
#clear
log I "switching to $BASH_USER env"


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]$BASH_USER@$BASH_HOST\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}$BASH_USER@$BASH_HOST:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}$BASH_USER@$BASH_HOST: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $BASH_HOME/.bash_aliases ]; then
    log D "    adding bash_aliases"
    . $BASH_HOME/.bash_aliases
fi

if [ -d $BASH_HOME/.bashsrc ]; then
    log D "    adding bashsrc"
    for src in $(find $BASH_HOME/.bashsrc/ -type f);
    do
	log D "        ++ $src"
        . $src
    done
fi

[ $PATH_BACKUP ] || export PATH_BACKUP="$PATH"
PATHES=
log D "    adding to PATH"
for my_path in ${BASH_PATHES[@]};
do
    [ -d "${!my_path}" ] && { log D "        ++ ${!my_path}"; PATHES="${!my_path}:$PATHES"; }
done
export PATH="${PATHES}:$PATH_BACKUP"

if [ -d $BASH_HOME/.bashenvs ]; then
    log D "    adding bash_envs"
    for env_file in $(find $BASH_HOME/.bashenvs/ -type f);
    do
        log D "        ++ $(basename $env_file)"
        eval "export $(basename $env_file)=\". $env_file\""
    done
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
[ -f $BASH_HOME/.bashtxt ] && . $BASH_HOME/.bashtxt || { [ -f $BASH_HOME/.bash_logo ] && . $BASH_HOME/.bash_logo; }

export LOG_LEVEL="INFO"
USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 0 2>  /dev/null
export CCACHE_DIR=/mnt/ccache
