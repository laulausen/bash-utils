#!/bin/bash

cd $HOME
git clone https://raw.githubusercontent.com/laulausen/bash-utils.git
cd bash-utils
[ -f $HOME/.bashrc ] && cp $HOME/.bashrc $HOME/._bashrc
cat << "EOF" >> $HOME/.bashrc
export BASH_HOME="$HOME"
export BASH_USER="GOD"
export BASH_HOST="HEAVEN"
#########################################################
# ######### Dirs to check and export ################## #
DIRS=( SDK )
#########################################################
SDK=$BASH_HOME/Sdk                                      #
#               SCRIPTS to IMPORT                       #
export BASHSRC=$BASH_HOME/.bashsrc                      #
#                                                       #
#             ENV_SETS FOR RUNNING                      #
export BASH_ENVS=$BASH_HOME/.bash_envs                  #
#                                                       #
#                   PATHES                              #
export BASH_BIN=$BASH_HOME/bin                          #
export BASH_SBIN=$BASH_HOME/.sbin                       #
PLATFORM_TOOLS=$SDK/platform-tools                      #
CMD_LINE_TOOLS=$SDK/cmdline-tools/latest/bin            #
AOSP_HOST_TOOLS=$BASH_BIN/aosp_host_tools               #
CMAKE=$SDK/cmake/3.22.1/bin                             #
BUILD_TOOLS=$SDK/build-tools/35.0.0                     #
#########################################################
BASH_PATHES=( PLATFORM_TOOLS AOSP_HOST_TOOLS CMD_LINE_TOOLS )
#########################################################

export TAG="ENV"
export logging=$BASHSRC/fun_log
[ -e "$logging" ] && . $logging
OLD_LEVEL=$LOG_LEVEL
export LOG_LEVEL="INFO"
#########################################################
cd $BASH_HOME
clear
log I "switching to $BASH_USER env"

export android_studio="/opt/android-studio/bin"
export ANDROID_HOME="$SDK"


if [ -f $BASH_HOME/.bash_aliases ]; then
    . $BASH_HOME/.bash_aliases
fi

if [ -d $BASH_HOME/.bashsrc ]; then
    for src in $(find $BASH_HOME/.bashsrc/ -type f);
    do
        . $src
    done
fi

[ $PATH_BACKUP ] || export PATH_BACKUP="$PATH"
PATHES=
for my_path in ${MY_PATHES[@]};
do
    [ -d "$my_path" ] && { log D "adding ${!my_path} to PATH"; export $my_path; PATHES="${!my_path}:$PATHES"; }
done
PATH="${PATHES}:$PATH_BACKUP"

if [ -d $BASH_HOME/.bashenvs ]; then
    for env_file in $(find $BASH_HOME/.bashenvs/ -type f);
    do
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

[ -f $BASH_HOME/.bash_logo ] && . $BASH_HOME/.bash_logo
EOF

cp -r .bash_logo .bash_aliases .bash_envs .bashsrc $HOME/
[ -d $HOME/.sbin ] || mkdir $HOME/.sbin
[ -d $HOME/bin ] || mkdir $HOME/bin
cd $HOME
echo "now type \". ./.bashrc\""

