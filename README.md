#!/bin/bash
# name          : fittrackee_installer.sh
# desciption    : install fittrackee on debian 12 netinstall 
# autor         : speefak ( itoss@gmx.de )
# licence       : (CC) BY-NC-SA
# version 	: 0.5
# notice 	:
# infosource	: https://speefak.spdns.de/oss_lifestyle/fittrackee-installation-unter-debian-12
#

# config/edit following parameter in script header if needed

 AdminUser="admin"					# admin username
 AdminPass="admin123"					# admin password - min. 8 characters

 PSQLUser=fittrackee					# postgreSQL user
 PSQLPass=fittrackeePW					# postgreSQL password
 PSQLData=fittrackee					# DO NOT CHANGE - otherwise error in database initiation 
 FitrackeeHost=0.0.0.0					# 0.0.0.0 for each client connection, except localhost / 127.0.0.1
 FitrackeePort=5000					# fittrackee port 


 
[![Watch the video](https://i.stack.imgur.com/Vp2cE.png)](https://youtu.be/vt5fpE0bzSY)

https://www.youtube.com/watch?v=YYGaDAcGZFM
