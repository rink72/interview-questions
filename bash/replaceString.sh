# function to print usage for the command if an incorrect parameter is specified
usage() { echo "Usage: $0 -f <filename> -e <regularexpression> -s <string>" 1>&2; exit 1; }


# Parse input arguments
while getopts ":f:e:s:" opt
  do
    case $opt in
      f ) file=$OPTARG;;
      e ) expression=$OPTARG;;
      s ) rString=$OPTARG;;
      * ) usage ; exit 1
    esac
  done


# Catch missing parameters
if [ -z $file ] || [ -z $expression ] || [ -z $rString ] ; then usage ; fi


# Run replacement and then display result of changes
sed -i 's/'"$expression"'/'"$rString"'/g' $file

# Output file
cat $file