# function to print usage for the command if an incorrect parameter is specified
usage() { echo "Usage: $0 -f <filename> -n <linenumber> -s <string>" 1>&2; exit 1; }


# Parse input arguments
while getopts ":f:n:s:" opt
  do
    case $opt in
      f ) file=$OPTARG;;
      n ) lineNumber=$OPTARG;;
      s ) rString=$OPTARG;;
      * ) usage ; exit 1
    esac
  done


# Catch missing parameters
if [ -z $file ] || [ -z $lineNumber ] || [ -z $rString ] ; then usage ; fi


# Run replacement

lineCount=`cat ${file} | wc -l`

counter=$lineNumber

while [ $counter -le $lineCount ]
do
  sed -i "${counter}i${rString}" $file
  counter=$(($counter + $lineNumber))
done
