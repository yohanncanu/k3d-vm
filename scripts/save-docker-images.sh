#!/usr/bin/env bash

dir=/vagrant/docker-load


docker rmi $(docker images --filter "dangling=true" -q --no-trunc) 2>/dev/null
docker images | awk '{if (!($1 ~ /^(REPOSITORY)/) )print $1 " " $2 " " $3 }' | tr -c "a-z A-Z0-9_.\n-" "%" | while read REPOSITORY TAG IMAGE_ID
do
    FILE="$dir/$REPOSITORY-$TAG.tar"
    if [ ! -f "$FILE" ]; then
        echo "== Saving $REPOSITORY $TAG $IMAGE_ID =="
        docker save -o $FILE $IMAGE_ID
    else
        echo "$FILE already exists"
    fi
done
docker images | sed '1d' | awk '{print $1 " " $2 " " $3}'