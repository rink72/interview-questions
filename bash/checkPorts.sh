# function to print usage for the command if an incorrect parameter is specified
usage() { echo "Usage: $0 -h <hostname> -p <port(s)> [[ -p <port(s)> ]]" 1>&2; exit 1; }


# Parse input arguments
while getopts ":h:p:" opt
  do
    case $opt in
      h ) host=$OPTARG;;
      p ) ports+=("$OPTARG");;
      * ) usage ; exit 1
    esac
  done


# Catch missing parameters
if [ -z $host ] || [ -z $ports ] ; then usage ; fi


# Iterate through ports and check if they are open
for port in "${ports[@]}"
  do
    results+=`nc -w5 -v -z $host $port`
  done

echo $results
