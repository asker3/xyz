#!/bin/bash
###################################
##  author:asker3
## 
## 
## onekey start/stop service
###################################

ser=(dhcpd httpd tftp)

start(){
  for i in "${ser[@]}"
  do
     systemctl is-active --quiet "$i" 2>/dev/null
     if [ $? -ne 0 ];then
      systemctl start "$i" && echo "Started $i" || echo "Failed to start $i"
     else
      echo "$i is already running"
     fi
  done
}

stop(){
  for i in "${ser[@]}"
  do
     systemctl is-active --quiet "$i" 2>/dev/null
     if [ $? -eq 0 ];then
      systemctl stop "$i" && echo "Stopped $i" || echo "Failed to stop $i"
     else
      echo "$i is not running"
     fi
  done
}

read -p "Input start or stop: " action
case $action in
    start) start ;;
    stop) stop ;;
    *) echo "USAGE:$0 {start|stop}"; exit 1 ;;
esac
