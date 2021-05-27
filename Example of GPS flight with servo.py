from __future__ import print_function
from dronekit import connect, VehicleMode, LocationGlobalRelative
from pymavlink import mavutil
import time
import argparse
# Set up option parsing to get connection string
parser = argparse.ArgumentParser()
parser.add_argument('--connect', default='127.0.0.1:14550')  #Creates connection between pi and pixhawk
args = parser.parse_args()

# Connect to the Vehicle
print ('Connecting to vehicle on: %s' % args.connect)
vehicle = connect(args.connect, baud=57600, wait_ready=True)  #Baud rate set for pi with pixhawk

# Function to arm and then takeoff to a user specified altitude
def arm_and_takeoff(aTargetAltitude):
  print ("Basic pre-arm checks")
  # Prevents arming until autopilot is ready
  while not vehicle.is_armable:
    print (" Waiting for vehicle to initialise...")
    time.sleep(1)
        
  print ("Arming motors")
  #Set mode if arming possible
  vehicle.mode    = VehicleMode("GUIDED")  #Set guided mode of the drone to start.
  vehicle.armed   = True

  while not vehicle.armed:   #Print waiting for arming until arming check is completed
    print (" Waiting for arming...")
    time.sleep(1)

  print ("3..2..1..Lift Off!")
  vehicle.simple_takeoff(aTargetAltitude) # Take off to target altitude

  # Check that vehicle has reached takeoff altitude
  while True:
    print (" Altitude: ", vehicle.location.global_relative_frame.alt)
    #Break and return from function just below target altitude.        
    if vehicle.location.global_relative_frame.alt>=aTargetAltitude*0.95: 
      print ("Reached altitude")
      break
    time.sleep(1)

# Initialize the takeoff sequence to 2 meters altitude, change value depending on users need.
arm_and_takeoff(2)

#Simple delay of how long you want it to hover before moving to the first way point.
time.sleep(5)

print ("Take off sequence completed")

#Set the initial airspeed
print("Set default airspeed to  2 m/s")
vehicle.airspeed = 2

#Check and print battery status
print("Battery State: %s" % vehicle.battery)

#Go to first way point    #Change values depending on location, lat and lon
print("Fly to first waypoint at 2 m/s @ 2m alt")
point0 = LocationGlobalRelative(34.998917, -120.460237, 2)  #CHANGE THESE GPS POINTS!!!!!!! #make a variable for location lat and long, last digit represents altitude
vehicle.simple_goto(point0, groundspeed=2) #Command to goto a location above at a groundspeed of 2m/s this changes speed.

#Delay between 2 points, allows drone to fly to the waypoint before going to next line of code.
time.sleep(60)  #seconds

#Go to second way point  
print("Go to second waypoint at 2 m/s @ 2 m alt")
point1 = LocationGlobalRelative(34.999875, -120.458936, 2)  
vehicle.simple_goto(point1,groundspeed=2) 

#Run the servo between the above waypoints.
#Change servo time based on length of dispensing route, timer also acts as delay
execfile('servo.py')

#Go to third waypoint
print("Go to third waypoint at 2 m/s @ 5 m alt")
point2 = LocationGlobalRelative(34.998683, -120.458848, 5)  
vehicle.simple_goto(point2,groundspeed=2) 

#If more waypoints are needed simply copy format and lable waypoint 4,5 etc.

#Land vehicle
print("The Eagle Has Landed")
vehicle.mode = VehicleMode("LAND")  #Change mode to land

#Check and print battery condition
print("Battery State: %s" % vehicle.battery)

# Close vehicle object before exiting script
print("Close vehicle object")
vehicle.close()
