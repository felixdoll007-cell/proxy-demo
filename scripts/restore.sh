#!/bin/bash

if [ -z "$1" ]; then
  echo "Bitte einen Volume-Namen angeben"           
  exit 1
fi

if ! [ -f "$1".tar.gz ]; then
echo "die datei gibt es nicht?"
exit 1 
fi 


docker run --rm \
  -v $1:/ziel \
  -v $(pwd):/quelle \
  alpine tar xzf /quelle/$1.tar.gz -C /ziel
