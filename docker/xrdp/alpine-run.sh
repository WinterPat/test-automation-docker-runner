#!/bin/bash


start_xrdp_services() {
    # Preventing xrdp startup failure
    #rm -rf /var/run/xrdp-sesman.pid
    #rm -rf /var/run/xrdp.pid
    #rm -rf /var/run/xrdp/xrdp-sesman.pid
    #rm -rf /var/run/xrdp/xrdp.pid

    ## Use exec ... to forward SIGNAL to child processes
    #xrdp-sesman && exec xrdp -n
    echo "Running.."
    rm -rf /var/run/xrdp-sesman.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid

    DISPLAY=:0
    export DISPLAY=$DISPLAY
    echo $NEW_USER
    su - $NEW_USER -c "/usr/bin/Xvfb $DISPLAY -screen 0 1920x1080x24" &
    /sbin/udevd &
    su - $NEW_USER -c "/usr/bin/x11vnc -passwd bar -xkb -noxrecord -noxfixes -noxdamage -display $DISPLAY -nopw -wait 5" &
    /usr/sbin/xrdp --nodaemon &
    /usr/sbin/xrdp-sesman --nodaemon &
    su - $NEW_USER -c "dbus-launch /usr/bin/xfce4-session --display=$DISPLAY" &
    /usr/sbin/sshd -D &
    sleep 10000

}

stop_xrdp_services() {
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}

echo Entryponit script is Running...

users=$(($#/3))
mod=$(($# % 3))

if [[ $# -eq 0 ]]; then 
    echo "No input parameters. exiting..."
    echo "there should be 3 input parameters per user"
    exit
fi

if [[ $mod -ne 0 ]]; then 
    echo "incorrect input. exiting..."
    echo "there should be 3 input parameters per user"
    exit
fi

echo "You entered $users users"

while [ $# -ne 0 ]; do
    addgroup -g 1001 -S $1           #group:foo
    wait
    adduser -G $1 -s /bin/sh -D $1   #user:foo
    wait
    addgroup $1 $1
    wait
    adduser $1 $1
    echo "$1:$1" | /usr/sbin/chpasswd                
    if [[ $3 == "yes" ]]; then       
        addgroup -g 1000 -S sudo    #group:sudo
        wait
        addgroup $1 sudo            #group:foo
        echo "$1    ALL=(ALL) ALL" >> /etc/sudoers
        wait
        echo $1:$2 | chpasswd 
        wait
    fi
    if [[ $3 == "no" ]]; then
        wait
        echo $1:$2 | chpasswd 
        wait
    fi
    wait
    echo "user '$1' is added"
    export NEW_USER=$1
    ssh-keygen -A

    # Shift all the parameters down by three
    shift 3
done

echo -e "This script is ended\n"

echo -e "starting xrdp services...\n"

trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp_services