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
#------------------------------------------------------------------------------------------------------------------------------------------------
############################################################################################################
#######################################   define global variables   ########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------------------------------------------

 AdminUser="admin"					# admin username
 AdminPass="admin123"					# admin password - min. 8 characters

 PSQLUser=fittrackee					# postgreSQL user
 PSQLPass=fittrackeePW					# postgreSQL password
 PSQLData=fittrackee					# DO NOT CHANGE - otherwise error in database initiation 
 FitrackeeHost=0.0.0.0					# 0.0.0.0 for each client connection, except localhost / 127.0.0.1
 FitrackeePort=5000					# fittrackee port 
 FitrackeePortClient=3000				# ?
 FittrackeeUser=$(whoami)

 RequiredPackets="sed python3-full python3-pip postgresql postgresql-client-common postgresql-client-15"

#------------------------------------------------------------------------------------------------------------------------------------------------
############################################################################################################
###########################################   define functions   ###########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------------------------------------------
load_color_codes () {
	Black='\033[0;30m'	&&	DGray='\033[1;30m'
	LRed='\033[0;31m'	&&	Red='\033[1;31m'
	LGreen='\033[0;32m'	&&	Green='\033[1;32m'
	LYellow='\033[0;33m'	&&	Yellow='\033[1;33m'
	LBlue='\033[0;34m'	&&	Blue='\033[1;34m'
	LPurple='\033[0;35m'	&&	Purple='\033[1;35m'
	LCyan='\033[0;36m'	&&	Cyan='\033[1;36m'
	LLGrey='\033[0;37m'	&&	White='\033[1;37m'
	Reset='\033[0m'
	# Use them to print in your required colours:
	# printf "%s\n" "Text in ${Red}red${Reset}, white and ${Blue}blue${Reset}."

	BG='\033[47m'
	FG='\033[0;30m'

	# parse required colours for sed usage: sed 's/status=sent/'${Green}'status=sent'${Reset}'/g' |\
	if [[ $1 == sed ]]; then
		for ColorCode in $(cat $0 | sed -n '/^load_color_codes/,/FG/p' | tr "&" "\n" | grep "='"); do
			eval $(sed 's|\\|\\\\|g' <<< $ColorCode)						# sed parser '\033[1;31m' => '\\033[1;31m'
		done
	fi
}
#------------------------------------------------------------------------------------------------------------------------------------------------
usage() {
	printf " iptables-blacklist version: $Version | script location $basename $0\n"
	clear
	printf "\n"
	printf " Usage: $(basename $0) <options> "
	printf "\n"
	printf " -h		=> (h)elp dialog \n"
	printf  "\n${Red} $1 ${Reset}\n"
	printf "\n"
	exit
}
#------------------------------------------------------------------------------------------------------------------------------------------------
check_for_required_packages () {

	InstalledPacketList=$(dpkg -l | grep ii | awk '{print $2}' | cut -d ":" -f1)

	for Packet in $RequiredPackets ; do
		if [[ -z $(grep -w "$Packet" <<< $InstalledPacketList) ]]; then
			MissingPackets=$(echo $MissingPackets $Packet)
		fi
	done

	# print status message / install dialog
	if [[ -n $MissingPackets ]]; then
		printf  "missing packets: \e[0;31m $MissingPackets\e[0m\n"$(tput sgr0)
		read -e -p "install required packets ? (Y/N) "			-i "Y" 		InstallMissingPackets
		if   [[ $InstallMissingPackets == [Yy] ]]; then

			# install software packets
			sudo apt update
			sudo apt install -y $MissingPackets
			if [[ ! $? == 0 ]]; then
				exit
			fi
		else
			printf  "programm error: $LRed missing packets : $MissingPackets $Reset\n\n"$(tput sgr0)
			exit 1
		fi

	else
		printf "$LGreen all required packets detected$Reset\n"
	fi
}
#------------------------------------------------------------------------------------------------------------------------------------------------
create_virtual_environent () {
	cd
	mkdir -p $HOME/fittrackee/uploads
	cd $HOME/fittrackee/
	python3.11 -m venv fittrackee_venv
}
#------------------------------------------------------------------------------------------------------------------------------------------------
install_fittrackee_in_virtual_environment () {
	source $HOME/fittrackee/fittrackee_venv/bin/activate
	pip install --upgrade pip
	pip install fittrackee
	deactivate
}
#------------------------------------------------------------------------------------------------------------------------------------------------
create_postgres_database () {
	printf " create postgre database: \n\n"
	printf "   CREATE USER $PSQLUser WITH PASSWORD '"$PSQLPass"'; \n"
	printf "   CREATE SCHEMA $PSQLData AUTHORIZATION $PSQLUser; \n"
	printf "   CREATE DATABASE $PSQLData OWNER $PSQLUser; \n\n"

	sudo -u postgres psql 2> /dev/null -c "CREATE USER $PSQLUser WITH PASSWORD '"$PSQLPass"';"
	sudo -u postgres psql 2> /dev/null -c "CREATE SCHEMA $PSQLData AUTHORIZATION $PSQLUser;"
	sudo -u postgres psql 2> /dev/null -c "CREATE DATABASE $PSQLData OWNER $PSQLUser;"
	printf "\n\n"

	# show users and databases
	sudo -u postgres psql 2> /dev/null -c "SELECT usename, datname FROM pg_user, pg_database WHERE pg_user.usesysid = pg_database.datdba;"
}
#------------------------------------------------------------------------------------------------------------------------------------------------
initiate_fittrackee_database () {
	source $HOME/fittrackee/fittrackee_venv/bin/activate
	source $HOME/fittrackee/env.cfg
	ftcli db upgrade
}
#------------------------------------------------------------------------------------------------------------------------------------------------
create_fittrackee_admin_accound () {
	source $HOME/fittrackee/fittrackee_venv/bin/activate
	source $HOME/fittrackee/env.cfg
	ftcli users create $AdminUser --email admin@root.net --password $AdminPass
	ftcli users update $AdminUser --set-admin true
}
#------------------------------------------------------------------------------------------------------------------------------------------------
print_fittrackee_URL_and_admin () {
	printf "fittrackee webservice:$Green $(hostname -I):$FitrackeePort $Reset \n"  | sed 's/ :/:/g'
	printf "fittrackee admin user:$Green admin@root.net $Reset \n"
	printf "fittrackee admin pass:$Green $AdminPass $Reset \n"
}
#------------------------------------------------------------------------------------------------------------------------------------------------
configure_fittrackee_python_virtual_environment () {

cat << EOF > env.cfg
# Custom variables initialisation
# (can overwrite variables present in Makefile.config)

# Application
# export FLASK_APP=fittrackee
export FLASK_SKIP_DOTENV=1
export HOST=$FitrackeeHost
export PORT=$FitrackeePort
export CLIENT_PORT=$FitrackeePortClient
# export APP_SETTINGS=fittrackee.config.ProductionConfig
export APP_SECRET_KEY='please change me'
# export APP_WORKERS=
export APP_LOG=$HOME/fittrackee/fittrackee.log
export UPLOAD_FOLDER=$HOME/fittrackee/uploads

# PostgreSQL
export DATABASE_URL=postgresql://$PSQLUser:$PSQLPass@localhost:5432/$PSQLData 
# export DATABASE_DISABLE_POOLING=

# Redis (required for API rate limits and email sending)
# export REDIS_URL=

# API rate limits
# export API_RATE_LIMITS="300 per 5 minutes"

# Emails
export UI_URL=
export EMAIL_URL=
export SENDER_EMAIL=
# export WORKERS_PROCESSES=

# Workouts
# export TILE_SERVER_URL=
# export STATICMAP_SUBDOMAINS=
# export MAP_ATTRIBUTION=
# export DEFAULT_STATICMAP=False

# Weather
# available weather API providers: visualcrossing
# export WEATHER_API_PROVIDER=
# export WEATHER_API_KEY=
EOF

# check environment configuration
nano env.cfg
source env.cfg
}
#------------------------------------------------------------------------------------------------------------------------------------------------
create_fittrackee_start_script () {
cat << EOF > start_fittrackee.sh
#!/bin/bash
# load environtent config
source $(echo ~FittrackeeUser)/fittrackee/fittrackee_venv/bin/activate
source $(echo ~FittrackeeUser)/fittrackee/env.cfg

# start fittrackee
if [[ -z \$(pgrep -a fittrackee) ]] ; then fittrackee ; else printf "\nfittrackee already running: \n\$(pgrep -a fittrackee)\n\n" ; fi

EOF
chmod 755 start_fittrackee.sh
sudo mv start_fittrackee.sh /usr/local/bin/
}
#------------------------------------------------------------------------------------------------------------------------------------------------
create_fittrackee_service () {
cat << EOF > fittrackee.service
[Unit]
Description="fittrackee sports tracker web app service"

[Service]
Type=oneshot
ExecStart=/bin/bash -c "sudo -u $FittrackeeUser start_fittrackee.sh &"
ExecStop=/bin/bash  -c "kill \$(pgrep fittrackee)"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
chmod 755 fittrackee.service
sudo mv fittrackee.service /etc/systemd/system/
sudo systemctl daemon-reload
}
#------------------------------------------------------------------------------------------------------------------------------------------------
############################################################################################################
#############################################   start script   #############################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------------------------------------------

	# check for root permission
	if [ ! "$(whoami)" = "root" ]; then echo "";else echo "You are Root !";exit 1;fi

#------------------------------------------------------------------------------------------------------------------------------------------------

#TODO	# configure dialog
#	AdminUser="admin"					# admin username
#	AdminPass="admin123"					# admin password - min. 8 characters

#	PSQLUser=fittrackee					# postgreSQL user
#	PSQLPass=fittrackeePW					# postgreSQL password
#	PSQLData=fittrackee					# DO NOT CHANGE - otherwise error in database initiation 
#	FitrackeeHost=0.0.0.0					# 0.0.0.0 for each client connection, except localhost / 127.0.0.1
#	FitrackeePort=5000					# fittrackee port 
#	FitrackeePortClient=3000				# ?

#------------------------------------------------------------------------------------------------------------------------------------------------

	load_color_codes
	check_for_required_packages
	create_virtual_environent
	install_fittrackee_in_virtual_environment
	configure_fittrackee_python_virtual_environment
	create_postgres_database
	initiate_fittrackee_database
	create_fittrackee_admin_accound
	create_fittrackee_start_script
	create_fittrackee_service
	print_fittrackee_URL_and_admin

#------------------------------------------------------------------------------------------------------------------------------------------------

exit

#------------------------------------------------------------------------------------------------------------------------------------------------

#TODO => change absolute install path - avoid $HOME var


# add admin accound
ftcli users create admin --email admin@root.net --password adminPassword
ftcli users update admin --set-admin true

# postgre commands
sudo -u postgres psql -c "DROP DATABASE fittrackee;"											# Datenbank löschen
sudo -u postgres psql -c "DROP USER fittrackee;"											# User löschen
sudo -u postgres psql 2> /dev/null -c "SELECT usename, datname FROM pg_user, pg_database WHERE pg_user.usesysid = pg_database.datdba;"	# User und Datenbanken anzeigen


