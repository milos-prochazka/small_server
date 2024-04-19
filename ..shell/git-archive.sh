#!/bin/sh
cd ..
CURRENTDATE=`date +"%Y-%m-%d %H-%M-%S"`
ARCHNAME=${PWD##*/}  
git archive -o "../$ARCHNAME $CURRENTDATE".zip HEAD

