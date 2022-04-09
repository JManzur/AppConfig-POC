#!/bin/bash

# App variables:
WORKDIR=/opt/sitcom_api
GU_CONFIG=api_gunicorn_config.py
APP=sitcom_api
PORT=8080
APP_URL=http://127.0.0.1:$PORT/

# Check parameters:
if [ $# -eq 0 ]
then
        echo "Parameter are needed. Run '$(basename $0) -h' for help"
        exit 1
fi

if [ $# -eq 1 ] && [ ${1} = "-h" ]
then
        echo "Usage: $(basename $0) {ACTION}"
        echo "START: $(basename $0) start"
        echo "STOP: $(basename $0) stop"
        echo "STOP: $(basename $0) status"
        echo "DUBUG: $(basename $0) debug"
        exit 0
fi

# Actions based on the given parameters:
case $1 in
    start|START)
        cd $WORKDIR
        gunicorn --config $GU_CONFIG $APP:app
        echo "$APP gunicorn deamon started at $APP_URL"
        exit 0
    ;;
    stop|STOP)
    if [ $(ps ax | grep gunicorn | grep $APP | awk '{print $1}' | head -n 1 | wc -l) -eq 1 ]
        then
            pkill gunicorn
            echo "Killed $APP gunicorn deamon"
            exit 0
        else
            echo "$APP gunicorn deamon not runningt"
            exit 1
        fi
    ;;
    status|STATUS)
    if [ $(ps ax | grep gunicorn | grep $APP | awk '{print $1}' | head -n 1 | wc -l) -eq 1 ]
        then
            echo "$APP gunicorn deamon is runningt"
            exit 0
        else
            echo "$APP gunicorn deamon not runningt"
            exit 1
        fi
    ;;
    debug|DEBUG)
        uvicorn $APP:app --port $PORT --reload
        exit 0
    ;;
    *)
        echo "$1 is not a valid parameter. Run '$(basename $0) -h' for help"
        exit 1
    ;;
esac