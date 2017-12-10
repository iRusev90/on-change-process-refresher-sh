#!/bin/bash

scriptExecutor=$1
scriptFile=$2
processToRefreshStartCommand="$scriptExecutor $scriptFile"
reloaderHomeDir=$(dirname $0)"/"
reloaderLogFile="$reloaderHomeDir""log/reloader.log"
removeFlagFileCommand="rm -f $reloaderHomeDir$2.flag"
isFirstWhileIteration=true

function showProcessRestartedSign {
    echo "" 
    echo "" 
    echo "" 
    echo "##################################################" 
    echo "#                                                #" 
    echo "#               process restarted                #" 
    echo "#                                                #" 
    echo "##################################################" 
    echo "" 
    echo "" 
    echo "" 
}

function log {
    logMessage=$(date)": $1"
    echo $logMessage >> $reloaderLogFile
}

function onScriptFirstStartSugar {
    log "starting script $scriptFile"
    echo ""
    echo ""
    isFirstWhileIteration=false
}

function onScriptRestartSugar {
    log "spawning new process due to alteration: $alterationDetails" 
    showProcessRestartedSign 
}

function logEventsAndPrettifyConsole {
    if [ "$isFirstWhileIteration" = true ]; then 
        onScriptFirstStartSugar
    else
        onScriptRestartSugar
    fi
}

eval $removeFlagFileCommand
sleep 1 && echo "" > $reloaderHomeDir$2.flag &

while [ 1 == 1 ]
do
    alterationDetails=$(inotifywait -e modify,create  $reloaderHomeDir)
    if [[ "$alterationDetails" == *"$2.flag"* ]] # if inotifywait output contains substring of arg 2
    then
        logEventsAndPrettifyConsole
        eval $processToRefreshStartCommand 
        eval $removeFlagFileCommand
    else 
        log "%alterationDetails does not match %2" 
        log "$alterationDetails" 
        log "$2" 
    fi
done
