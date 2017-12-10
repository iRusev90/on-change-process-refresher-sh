#!/bin/bash
reloaderHomeDir=$(dirname $0)"/"
bash "$reloaderHomeDir"killer.sh $1 $2 & 
bash "$reloaderHomeDir"cleaner.sh $1 $2 & 
bash "$reloaderHomeDir"spawner.sh $1 $2 
