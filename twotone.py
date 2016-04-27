#!/usr/bin/python3

from time import sleep
from RPi import GPIO

GREEN = 11
INTENSITY = 13
VSYNC = 18

STRIPE = 1/120
SYNCLENGTH = 1/1200

GPIO.setmode(GPIO.BOARD)
GPIO.setup(GREEN, GPIO.OUT)
GPIO.setup(INTENSITY, GPIO.OUT)
GPIO.setup(VSYNC, GPIO.OUT)

GPIO.output(INTENSITY, True)

while True:
    GPIO.output(GREEN, True)
    sleep(STRIPE)
    GPIO.output(GREEN, False)
    sleep(STRIPE)
    GPIO.output(VSYNC, False)
    sleep(SYNCLENGTH)
    GPIO.output(VSYNC, True)
