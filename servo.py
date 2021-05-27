import RPi.GPIO as GPIO
import time

##Pi GPIO pin setup
servoPIN=17
GPIO.setmode(GPIO.BCM)
GPIO.setup(servoPIN, GPIO.OUT)
##GPIO Servo timer
p=GPIO.PWM(servoPIN, 50) # GPIO Pin 17 used @ 50Hz PWM
p.start(0) #Start
now=time.time()
start=now
end=now+30   ## this will change the duration of the servo run time. Current settings has it at 30 seconds.
##below loop for the duty cycle can be changed based on the users needs.
while now < end:
		print("move servo")
		p.ChangeDutyCycle(0)
		time.sleep(1)
		p.ChangeDutyCycle(2)
		time.sleep(.05)
		p.ChangeDutyCycle(4)
		time.sleep(.05)
		p.ChangeDutyCycle(6)
		time.sleep(.05)
		p.ChangeDutyCycle(8)
		time.sleep(.05)
		p.ChangeDutyCycle(10)
		time.sleep(.05)
		p.ChangeDutyCycle(12)
		time.sleep(.05)
		p.ChangeDutyCycle(14)
		time.sleep(1)
		p.ChangeDutyCycle(12)
		time.sleep(.05)
		p.ChangeDutyCycle(10)
		time.sleep(.05)
		p.ChangeDutyCycle(8)
		time.sleep(.05)
		p.ChangeDutyCycle(6)
		time.sleep(.05)
		p.ChangeDutyCycle(4)
		time.sleep(.05)
		p.ChangeDutyCycle(2)
		time.sleep(.05)
		now =time.time()
print("time up")
p.stop()
GPIO.cleanup()
