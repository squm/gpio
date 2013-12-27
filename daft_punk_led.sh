#!/bin/sh

setup() {
  rmmod leds_gpio

  echo 0 > /sys/class/gpio/export
  echo 1 > /sys/class/gpio/export
  echo 12 > /sys/class/gpio/export
  echo 13 > /sys/class/gpio/export
  echo 14 > /sys/class/gpio/export
  echo 15 > /sys/class/gpio/export
  echo 16 > /sys/class/gpio/export
  echo 17 > /sys/class/gpio/export
}

on() {
  id=$1
  on=$2
  neg=$((!on))

  if [ "$#" -ne 2 ] || ([ $on -ne 0 ] && [ $on -ne 1 ])
  then
    echo "Usage: on 1-8 1-0 (got '$0 $id $on')"
    exit 1;
  fi

  case "$id" in
    8) echo $on > /sys/class/gpio/gpio0/value ;;
    7) echo $on > /sys/class/gpio/gpio17/value ;;
    6) echo $on > /sys/class/gpio/gpio16/value ;;
    5) echo $on > /sys/class/gpio/gpio15/value ;;
    4) echo $on > /sys/class/gpio/gpio14/value ;;
    3) echo $on > /sys/class/gpio/gpio13/value ;;
    2) echo $neg> /sys/class/leds/ath9k-phy0/brightness ;;
    1) echo $on > /sys/class/gpio/gpio1/value ;;
  esac
}

gauge() {
  id=0
  for on in "$@"
  do
    id=$((id+1))
    on $id $on
  done
}

load() {
  case "$1" in
    10) gauge 0 0 0 0 0 0 0 0 ;;
    9)  gauge 0 0 0 0 0 0 0 0 ;;
    8)  gauge 0 0 0 0 0 0 0 0 ;;
    7)  gauge 0 0 0 0 0 0 0 1 ;;
    6)  gauge 0 0 0 0 0 0 1 1 ;;
    5)  gauge 0 0 0 0 0 1 1 1 ;;
    4)  gauge 0 0 0 0 1 1 1 1 ;;
    3)  gauge 0 0 0 1 1 1 1 1 ;;
    2)  gauge 0 0 1 1 1 1 1 1 ;;
    1)  gauge 0 1 1 1 1 1 1 1 ;;
    0)  gauge 1 1 1 1 1 1 1 1 ;;
    *) echo "Usage: $0 0-10 got ('$@')" ;;
  esac
}

avg() {
  # avg=$(cat loadavg | head -c 3)
  avg=$(cat /proc/loadavg | head -c 3)
  avgi=$(echo $avg | awk '{print int($avg * 10)}')
  avgj=$(echo $avgi | awk '{print ($avgi > 10 ? 10 : $avgi)}')
}

loop_gauge() {
  while true
  do
    echo "load '$avg', '$avgi', '$avgj'"
    load $avgj
    sleep 1
  done
}

loop_daft_punk() {
  # while true; do

    echo 1 > /sys/class/gpio/gpio0/value; sleep 1
    echo 1 > /sys/class/gpio/gpio17/value; sleep 1
    echo 1 > /sys/class/gpio/gpio16/value; sleep 1
    echo 1 > /sys/class/gpio/gpio15/value; sleep 1
    echo 1 > /sys/class/gpio/gpio14/value; sleep 1
    echo 1 > /sys/class/gpio/gpio13/value; sleep 1
    echo 0 > /sys/class/leds/ath9k-phy0/brightness; sleep 1
    echo 1 > /sys/class/gpio/gpio1/value; sleep 1
    echo 0 > /sys/class/gpio/gpio1/value; sleep 1
    echo 1 > /sys/class/leds/ath9k-phy0/brightness; sleep 1
    echo 0 > /sys/class/gpio/gpio13/value; sleep 1
    echo 0 > /sys/class/gpio/gpio14/value; sleep 1
    echo 0 > /sys/class/gpio/gpio15/value; sleep 1
    echo 0 > /sys/class/gpio/gpio16/value; sleep 1
    echo 0 > /sys/class/gpio/gpio17/value; sleep 1
    echo 0 > /sys/class/gpio/gpio0/value; sleep 1

  # done
}

loop() {
  while true
  do
    avg

    if [ $avgj -lt 1 ]
    then
      echo "idle"
      loop_daft_punk
    else
      echo "load '$avg', '$avgj'"
      load $avgj
      sleep 1
    fi

  done
}

setup
loop
