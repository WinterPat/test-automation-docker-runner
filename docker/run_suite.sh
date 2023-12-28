#!/bin/bash
# Aja Robot Framework Framework RPA-prosessi virtuaalinäytöllä.
Help()
{
  echo "Variables:"
  echo "-s test tag (mandatory)"
  echo "-u username (mandatory)"
  echo "-p password (mandatory)"
}

# Muuttujien  määritys ja tarkistus.
while getopts ":hs:u:p:" opt; do
  case $opt in
    h)  Help
        exit;;
    s)  suite=$OPTARG;;
    u)  username=$OPTARG;;
    p)  password=$OPTARG;;
    *)  echo "Error: Variable error"
        Help
        exit 1;;
  esac
done


# Käynnistä ja kohdista suoratoisto nginx-rtmp-serverille. Avaa suoratoisto ja käynnistä prosessi.
# Aseta virtuaalinäyttö and ikkunamanageri.
export DISPLAY=:98
python3 -m robot -x outputxunit.xml --listener listeners/recorder.py:on:$suite --outputdir reports/robot_results_$suite -i $suite -v default_username:$username -v default_password:$password .