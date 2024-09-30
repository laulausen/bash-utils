#!/bin/bash
echo 'export ENVS=~/.envs' >> ~/.bashrc
echo 'export logging=~/.bashsrc/fun_log' >> ~/.bashrc
echo '. $logging' >> ~/.bashrc
echo 'export BASH_VARS_FILE=~/.bashvars' >> ~/.bashrc
echo 'export env=". $ENVS/.env"' >> ~/.bashrc

FILES=".bashsrc .bashvars .envs .sbin"
for f in $FILES; do
  [ ! -e ~/$f ] && cp -r $f ~/
done 
