#!/bin/bash
cd ~/.ddp/ddp-projet/"$1"
if [ $? -eq 1 ] ; then
    echo "ERREUR-> : \"$1\" EST INTROUVABLE"
else
    rep=$(cat chemin.txt)
    cd "$rep"
    echo "SUCCES :)"
fi