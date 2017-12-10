#!/bin/bash

scriptExecutor=$1
scriptFile=$2
reloaderHomeDir=$(dirname $0)"/"
currentDir=$(pwd)
reloaderLogFile="$reloaderHomeDir""log/reloader.log"
killOldProcessCommand="pkill -f -x '$scriptExecutor $scriptFile' >> $reloaderLogFile"

function log {
    logMessage=$(date)": $1"
    echo $logMessage >> $reloaderLogFile
}

inotifywait -m -e modify  $currentDir | while read alterationDetails
do
    if [[ "$alterationDetails" == *"$scriptFile"* ]] 
    then
        log "killing old process: $killOldProcessCommand" 
        eval $killOldProcessCommand 
        echo "" > $reloaderHomeDir$2.flag
    else 
        log "not to be killed" 
        log "rejected reload on:" 
        log $alterationDetails 
    fi
done
