#!/bin/sh
utcs="name"
fullname=$(basename $0)
shortname=${fullname%.*}
output=$(ruby "$shortname".rb)
ssh $utcs@$output
