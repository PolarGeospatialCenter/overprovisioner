#!/bin/bash

OSD_DEVICE=$1

if [[ ! -b $OSD_DEVICE ]]; then
  echo "Usage: overprovision /dev/<device>"
  exit 1
fi 

hdparmOutput=$(hdparm -N $OSD_DEVICE 2>/dev/null || echo -n "")
if [[ $hdparmOutput == "" ]]; then
  echo "HDParm returned error or nothing, assuming regular hdd"
  exit 0
fi

availableSize=$(printf "$hdparmOutput" | gawk '{if (match($0, /([0-9]+)\/([0-9]+), HPA/, arr)){ print arr[1] }}')
totalSize=$(printf "$hdparmOutput" | gawk '{if (match($0, /([0-9]+)\/([0-9]+), HPA/, arr)){ print arr[2] }}')
if [ $availableSize -eq $totalSize ]; then
    echo "Attempting to overprovision ssd, reboot required to take effect"
    newAvailableSize=$(($totalSize * 1024/1000 * 3/4))
    hdparm -Np$newAvailableSize --yes-i-know-what-i-am-doing $OSD_DEVICE
    availableSize=$newAvailableSize
fi

currentReportedSize=$(blockdev --getsize $OSD_DEVICE)
if [ $availableSize -eq $currentReportedSize ]; then
  exit 0
fi


exit 2
