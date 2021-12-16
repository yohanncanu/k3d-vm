#!/usr/bin/env bash

dir=/vagrant/docker-load
for f in $dir/*.tar
do
    echo "load $f"
    docker load -i $f
done