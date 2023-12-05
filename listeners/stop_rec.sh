#!/bin/bash
curl -s "http://localhost:80/control/record/stop?app=show&name=TA-stream&rec=rec"
echo "Recording Stops.."
sleep 1s