#!/bin/sh

BRANCH="master"

cd ..
CURRENTDATE=`date +"%Y-%m-%d %H-%M-%S"`
ARCHNAME=${PWD##*/}  

git archive -o "../$ARCHNAME $CURRENTDATE".zip HEAD
dart-prep --enable-all ./
dart-format ./ 2

git stash push -m "git pull - $CURRENTDATE"
git checkout $BRANCH
git fetch origin $BRANCH
git rebase -i origin/$BRANCH
git pull

cd ..config
./selected-config.sh
