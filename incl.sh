#!/bin/sh
file="$1"
if [ -z "$file" ]
then
    echo no file
    exit
fi

while IFS= read -r line <&3
do
    if echo "$line" | grep '^%include[^"]*"[^"]*".*$' > /dev/null
    then
        included=$(echo "$line" | sed -e 's/^%include[^"]*"\([^"]*\)".*$/\1/')
        if [ -f "$included" ]
        then
            echo $'\t'"; module \"$included\""
            cat $included
        else
            echo $'\t'"; module NOT FOUND: \"$included\""
        fi
    else
        echo "$line"
    fi
done 3< "$file"

