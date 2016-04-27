#!/usr/bin/python3

from time import sleep
from RPi import GPIO

GPIO.setmode(GPIO.BOARD)
GPIO.setup(7, GPIO.OUT)

while True:
    GPIO.output(7, True)
    sleep(1)
    GPIO.output(7, False)
    sleep(1)
