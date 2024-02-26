#!/bin/bash
# name          : fittrackee_installer.sh
# desciption    : install fittrackee on debian 12 netinstall 
# autor         : speefak ( itoss@gmx.de )
# licence       : (CC) BY-NC-SA
# version 	: 0.5
# notice 	:
# infosource	: https://reintech.io/blog/installing-postgresql-on-debian-12-for-beginners
#		  https://astrid-guenther.de/fittrackee-uberspace-installation/#fittrackee-installieren-und-virtuelle-umgebung-f%C3%BCr-python-einrichten
#		  https://lab.uberspace.de/guide_postgresql/
#		  https://samr1.github.io/FitTrackee/en/index.html
#

# config/edit following parameter in script header if needed
 AdminUser="admin"					# admin username
 AdminPass="admin123"					# admin password - min. 8 characters

 PSQLUser=fittrackee					# postgreSQL user
 PSQLPass=fittrackeePW					# postgreSQL password
 PSQLData=fittrackee					# DO NOT CHANGE - otherwise error in database initiation 
 FitrackeeHost=0.0.0.0					# 0.0.0.0 for each client connection, except localhost / 127.0.0.1
 FitrackeePort=5000					# fittrackee port 
