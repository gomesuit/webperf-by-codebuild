#!/bin/bash -x

awk -F, '{ print $1 " " $2 " " $3 }' urls.csv | xargs -n 3 ./sitespeed.sh
