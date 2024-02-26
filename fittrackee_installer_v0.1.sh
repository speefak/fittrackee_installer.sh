#!/bin/bash  
# python 3.11 installed from repo ## https://reintech.io/blog/installing-postgresql-on-debian-12-for-beginners
# https://astrid-guenther.de/fittrackee-uberspace-installation/#fittrackee-installieren-und-virtuelle-umgebung-f%C3%BCr-python-einrichten
# https://lab.uberspace.de/guide_postgresql/
# https://samr1.github.io/FitTrackee/en/index.html
#-------------------------------------------------------------------------------------------------------------------------------------------

PSQLUser=fittrackee
PSQLPass=fittrackeePW
PSQLData=fittrackee
FitrackeeHost=0.0.0.0
FitrackeePort=5000
FitrackeePortClient=3000

#-------------------------------------------------------------------------------------------------------------------------------------------
# install python 3.11 
sudo apt install -y python3-full python3-pip postgresql postgresql-client-common postgresql-client-15

# create virtual environent
cd
mkdir -p $HOME/fittrackee/uploads
cd $HOME/fittrackee/
python3.11 -m venv fittrackee_venv

#-------------------------------------------------------------------------------------------------------------------------------------------

# install fittrackee in virtual environment
source fittrackee_venv/bin/activate
pip install --upgrade pip
pip install fittrackee
deactivate

#-------------------------------------------------------------------------------------------------------------------------------------------

# create postgres database
# create user and database and grand access

printf " create postgre database: \n\n"
printf "   CREATE USER $PSQLUser WITH PASSWORD '"$PSQLPass"'; \n"
printf "   CREATE SCHEMA $PSQLData AUTHORIZATION $PSQLUser; \n"
printf "   CREATE DATABASE $PSQLData OWNER $PSQLUser; \n\n"

sudo -u postgres psql 2> /dev/null -c "CREATE USER $PSQLUser WITH PASSWORD '"$PSQLPass"';"
sudo -u postgres psql 2> /dev/null -c "CREATE SCHEMA $PSQLData AUTHORIZATION $PSQLUser;"
sudo -u postgres psql 2> /dev/null -c "CREATE DATABASE $PSQLData OWNER $PSQLUser;"

# show users and databases
sudo -u postgres psql 2> /dev/null -c "SELECT usename, datname FROM pg_user, pg_database WHERE pg_user.usesysid = pg_database.datdba;"

#-------------------------------------------------------------------------------------------------------------------------------------------

# configure fittrackee via python virtual environment 
# use following file content, edit database connection and email config

cat << EOF > env.cfg
# Custom variables initialisation
# (can overwrite variables present in Makefile.config)

# Application
# export FLASK_APP=fittrackee
export FLASK_SKIP_DOTENV=1
export HOST=$PSQLHost
export PORT=$FitrackeePort
export CLIENT_PORT=$FitrackeePortClient
# export APP_SETTINGS=fittrackee.config.ProductionConfig
export APP_SECRET_KEY='please change me'
# export APP_WORKERS=
export APP_LOG=fittrackee.log
export UPLOAD_FOLDER=$HOME/fittrackee/uploads

# PostgreSQL
# <host>:<port>:<database>:<user>:<password>

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
#-------------------------------------------------------------------------------------------------------------------------------------------

# start virtual python environment and load environment config via source .env
cd fittrackee/
source fittrackee_venv/bin/activate
source env.cfg

# update database
ftcli db upgrade

#-------------------------------------------------------------------------------------------------------------------------------------------

# create start script
cat << EOF > start_fittrackee.sh
# load environtent config
source fittrackee_venv/bin/activate
source env.cfg

# start fittrackee
if [[ -z \$(pgrep -a fittrackee) ]] ; then fittrackee ; else printf "\nfittrackee already running: \n\$(pgrep -a fittrackee)\n\n" ; fi

EOF
chmod 755 start_fittrackee.sh

#-------------------------------------------------------------------------------------------------------------------------------------------

exit

# add admin accound
ftcli users create admin --email admin@root.net --password adminPassword
ftcli users update admin --set-admin true

# database commands
sudo -u postgres psql -c "DROP DATABASE datenbankname;"		# Datenbank löschen
sudo -u postgres psql -c "DROP USER benutzername;"		# User löschen


