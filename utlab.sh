#!/bin/sh
utcs="name"
shortname=${0%.*}
output=$(ruby "$shortname".rb)
ssh $utcs@$output
