#!/bin/bash

scriptExecutor=$1
scriptFile=$2
reloaderHomeDir=$(dirname $0)"/"
reloaderLogFile="$reloaderHomeDir""log/reloader.log"

function log {
    logMessage=$(date)": $1"
    echo $logMessage >> $reloaderLogFile
}

#somehow this thing is very efficient and always works exactly when I stop the reloader without actually going though the loop a billion times
function cleanKillerWhenSpawnerIsDead {

    startRealodingShFullPath=$reloaderHomeDir"startReloading.sh"
    spawnProcessShFullPath=$reloaderHomeDir"spawner.sh"
    spawnerPid=$(pgrep -f -x "bash $spawnProcessShFullPath $scriptExecutor $scriptFile")

    if [ -z "$spawnerPid" ]; then 
      killerShFullPath=$reloaderHomeDir"killer.sh"
      killerProcess="bash $killerShFullPath $scriptExecutor $scriptFile"
      cleanKillerCommand="pkill -f -x '$killerProcess' >> $reloaderLogFile"
      log "process bellow is gone" 
      log "bash $spawnProcessShFullPath $scriptExecutor $scriptFile" 
      log "clearingKiller" 
      eval $cleanKillerCommand
      log "clearing flag file if such exists"
      clearFlagFileCommand="rm -f "$reloaderHomeDir$scriptFile".flag"
      eval $clearFlagFileCommand
   else 
      sleep 5 && cleanKillerWhenSpawnerIsDead
  fi 
    
}

sleep 5 && cleanKillerWhenSpawnerIsDead
