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

loop() {
  while true; do

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

  done
}

setup
loop
