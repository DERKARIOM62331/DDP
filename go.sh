#!/bin/bash
rep=$(cat ~/.ddp/ddp-projet/"$1"/chemin.txt 2> /dev/null)
if [ "$?" -eq 1 ] ; then
    echo "ERREUR-> : \"$1\" EST INTROUVABLE"
else
    cd "$rep" 2> /dev/null
fi