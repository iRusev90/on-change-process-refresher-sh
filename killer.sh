#!/bin/bash

scriptExecutor=$1
scriptFile=$2
reloaderHomeDir=$(dirname $0)"/"
flagFileDir=$reloaderHomeDir"tmp/"
currentDir=$(pwd)
reloaderLogFile="$reloaderHomeDir""log/reloader.log"
killOldProcessCommand="pkill -f -x '$scriptExecutor $scriptFile'"

function log {
    logMessage=$(date)": $1"
    echo $logMessage >> $reloaderLogFile
}

flagIteration=0
inotifywait -m -e modify  $currentDir | while read alterationDetails
do
    if [[ "$alterationDetails" == *"$scriptFile"* ]] 
    then
		log "alteration details: $alterationDetails"
        log "killing old process: $killOldProcessCommand" 
        eval $killOldProcessCommand" >> $reloaderLogFile"
		log "creating flag file $flagFileDir$2.flag"
		((flagIteration++))
        echo "" > $flagFileDir$2.flag$flagIteration
    else 
        log "not to be killed" 
        log "rejected reload on:" 
        log $alterationDetails 
    fi
done
