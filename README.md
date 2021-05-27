# uav_pollination
Open source agricultural uav 

<img src="https://github.com/ducati-748/uav_pollination/blob/f15ff90de3834e43ba4d2dd499e91747f48af6a1/images/drone2.jpg">

Below is a parts list of the general components needed, note these can be replaced with equivalant parts based on the users needs and budget.
<img src="https://github.com/ducati-748/uav_pollination/blob/b1611374fa8e634344bf9eeaa881ec9e8b1d9ec2/images/parts%20list.JPG">

<img src="https://github.com/ducati-748/uav_pollination/blob/2c97cbe5140ba7bc7d8e841b2e7a5df8655a2493/images/layout2.jpg">

Mounting of the companion computer. Raspberry pi 3 b+ (note other models may be used including Pi zero)
<img src="https://github.com/ducati-748/uav_pollination/blob/b9de5848b2975f00ab818d14ece72b5a2f62d920/images/pi.jpg">
FLight controller used Pixhawk
<img src="https://github.com/ducati-748/uav_pollination/blob/81d1e67641a2e505f54ac2ba9b96079bcad990b3/images/pixhawk.jpg">


Raspberry pi libraries.
-sudo apt-get install python-pip
-sudo apt-get install python-dev
-sudo pip install future
-sudo apt-get install screen python-wxgtk4.0 python-lxml
-sudo pip install pyserial
-sudo pip install dronekit
-sudo pip install MAVProxy

Enable serial port communication
sudo raspi-config
Set serial port hardware to enabled

