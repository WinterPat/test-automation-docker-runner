#!/bin/bash

# Aseta virtuaalinäyttö
#echo "Starting virtual screen.."
#Xvfb :99 -screen 0 1920x1080x24  &
#export DISPLAY=:99
#sleep 10s

# Käynnistä nginx-rtmp-hls-serveri
echo "Starting NGINX.."
nginx -g 'daemon off;' &

# Wait for NGINX to start
while true; do
    if curl -s --head http://localhost:80 2>&1 | grep "200 OK" > /dev/null; then
        echo "NGINX is up and running."
        break
    else
        echo "Waiting for NGINX to start..."
        sleep 1
    fi
done

echo "Starting xrdp session"
./ubuntu-run

# Aloita suoratoisto
echo "Starting stream.."
ffmpeg -loglevel error -f x11grab -i $DISPLAY -s 1920x1080 -c:v libx264 -x264opts keyint=60:no-scenecut -c:a copy -r 30 -tune zerolatency -preset veryfast -f flv rtmp://localhost:1935/show/TA-stream

sleep 100000
# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
echo "Starting testautomation suite.."
./run.sh "$@" & wait $!
