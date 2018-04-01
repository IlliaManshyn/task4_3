#!bin/bash

waytosave=/tmp/backups

if ! [ -d $waytosave ]
then
mkdir $waytosave
fi

OLDESTBAK=$(ls -t "$waytosave" | grep "$NAMEOFBAKARCH**" | tail -n 1)
SOURCE="$1"
NUMBAK=$2
NAMEOFBAKARCH=$(echo "$SOURCE" | sed 's/\///1' | sed 's/\//-/g' | sed 's/^-//' )
NUMOFBAKEXISTS=$(ls -ltu $waytosave | grep "$NAMEOFBAKARCH**" | wc -l)

if [[ $# -ne 2 ]]
then
echo "ERROR: Incorrect number of args" >&2
exit 1
fi

if ! [ -d "$1" ]
then
echo "ERROR: '$1' It's not a directory" >&2
exit 2
fi

re='^[0-9]+$'
if ! [[ $2 =~ $re ]]
then
   echo "error: Not a number" >&2
exit 3
fi

cd $waytosave
tar  -zcpf "$NAMEOFBAKARCH""$(date +%Y-%m-%d-%H%M%S)".tar.gz $SOURCE 2>/dev/null

ls  $waytosave | grep "$NAMEOFBAKARCH**" | sort -n | head -n -$NUMBAK | sed "s/.*/\"&\"/" | xargs rm -f

exit 0
