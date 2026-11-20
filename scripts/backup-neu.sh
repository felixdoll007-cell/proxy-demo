#!/bin/bash
if [ -z "$1" ]; then 
  echo "bitte einen namen eingeben"
  exit 1 
fi 



if ! docker volume inspect "$1" > /dev/null 2>&1; then
echo "volumen gibt es nicht"
exit 1
fi


docker run --rm \
  -v $1:/quelle:ro \
  -v $(pwd):/ziel \
  alpine tar czf /ziel/$1.tar.gz -C /quelle .
  sudo chown $USER:$USER  ./$1.tar.gz 


