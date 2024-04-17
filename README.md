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
 FitrackeeHost=0.0.0.0					# 0.0.0.0 for each client connection, except 127.0.0.1
 FitrackeePort=5000					# fittrackee port 


Documentation       => https://speefak.spdns.de/oss_lifestyle/fittrackee-installation-unter-debian-12
Installation Video  => https://youtu.be/YYGaDAcGZFM

REAR ISO Image      => https://drive.google.com/file/d/1DJMHKrH1NbQKVlxnfhqYQwCWrRx57Er9
REAR install Video  => https://youtu.be/9YokUFJalB8 
OS Login            => user: user | pass: user
Fittrackee weblogin => admin@root.net | pass: admin 123
