#!/bin/bash
# Le manuel de Derkariom depot des projet(DDP)
manuel()
{
    clear
    echo -e "\n\nLEGANT: OU(|) ET(&)\n"
    echo -e "\n\nddp -v -> POUR VOIR LA VERSION DE DDP\n"
    echo -e "ddp new | add -> POUR AJOUTER UN NOUVEAU PROJET\n"
    echo -e "ddp <nom_projet> <chemin_projet> add -> POUR CREE UN DEPOT DU CHEMIN DE VOTRE PROJET\n"
    echo -e "ddp log -> POUR LISTE LES PROJET DEPOSE SUR DDP\n"
    echo -e "ddp del -> POUR SUPRIME UN PROJET\n"
    echo -e "ddp code <projet> -> POUR OUVRIRE LE PROJET AVEC VSCODE\n"
    echo -e "ddp open <projet> -> POUR OUVRIRE LE PROJET AVEC EXPLORER\n"
    echo -e "ddp run | -x <projet> -> POUR EXECUTER UN PROJET\n"
    echo -e "ddp projet -o | out -> POUR COMPILE UN PROJET\n"
    echo -e "ddp projet -ox | xout -> POUR COMPILE ET EXECUTER UN PROJET\n"
}
declare -i k
declare -i i
repa=$(pwd) # pour sauvegarde le repertoir actuelle avant l' appelle de la commande
cd ~/      # pour ce rendre au repertoire utilisateurs

# Creation du repertoire .ddp dans le repertoire utilisateurs s'il n'exist pas
if [ ! -d ".ddp" ]  ; then
    mkdir .ddp
else
    cd .ddp/ # pour ce rendre dans le repertoire .ddp

    # Creation du sous repertoire ddp-projet dans le repertoire .ddp
    if [ ! -d "ddp-projet" ] ; then
        mkdir ddp-projet
    fi
fi

# Si le nombre d' argument vaut zero(0) 
if [ $# -eq 0 ] ; then
    echo "ERREUR-> AUCUN PARAMETRE"

# -v pour voir la version de Derkariom depot de projet (DDP)
elif [ "$1" = "-v" -o "$1" == "--version" ] ; then
    echo "DERKARIOM DEPOT DES PROJET VERSION 1.9 BETA :)"

# pour visiter le manuel de Derkariom depot des projet (DDP)
elif [ "$1" == "-h" -o "$1" == "--help" ] ; then
    manuel | less

# Syntax: ddp new | add : pour cree un nauvaut projet
elif [ "$1" = "new" -o "$1" = "add" ] ; then
# new est une variable qui prent le nom du projet
# chemin est une variable qui prent le chemin du repertoire du projet de base
# compiler est une variable qui prent le code de compilation du projet
# execution est une variable qui prent le code d'execution du projet   
    clear
    k=0
    until [ $k -lt 0 ]
    do
        read -p "NOM DU NOUVEAU PROJET : " new
        cd ~/.ddp/ddp-projet
        if [ -e "$new" ] ; then
            echo -e "\nERREUR -> ${new^^} : CE PROJET EXISTE !\n"
        else
            k=-1 # Cas d' arret de la boucle until
        fi
    done
k=0
until [ $k -lt 0 ]
do
    read -p "CHEMIN DU PROJET : " chemin
    cd "$chemin" 2> /dev/null
    if [ "$?" -eq 0 ] ; then
        k=-1  # Cas d' arret de la boucle until
    else
        echo -e "\n${chemin^^} EST INTROVABLE!\n"
    fi
done
    read -p "CODE DE CONPILATION:" compiler
    read -p "CODE D' EXECUTION:" execution
    cd ~/.ddp/ddp-projet ; mkdir "$new" #Creation du basse de donne du project
    if [ "$?" -eq 0 ] ; then 
        echo "$chemin" > "$new"/chemin.txt
        if [ "$compiler" != "" ] ; then
            echo "$compiler" > "$new"/compiler.txt
        fi
        if [ "$execution" != "" ] ; then
            echo "$execution" > "$new"/execution.txt
        fi
   fi  

# Syntax: ddp log : pour lister toute les depot
elif [ "$1" == "log" -a "$#" -eq 1 ] ; then
    cd ~/.ddp/ddp-projet 2> /dev/null
    if [ "$?" -eq 0 ] ; then
        echo -e "\t\tLISTE DES PROJET\n"
        i=1
        for pro in *
        {
            if [ -d "$pro" ] ; then
                echo -e "\n$i -> ${pro}"
                i=i+1
            fi
        } 
    else
        echo "ECHEC !"
    fi

# Syntax: ddp del <projet> : pour suprimer le depot d' un projet 
elif [ "$1" == "del" -a "$#" -eq 2 ] ; then
    cd ~/.ddp/ddp-projet 2> /dev/null
    if [ "$?" -eq 0 ] ; then
        if [ -e "$2" ] ; then
            rm -r "$2"
        else
            echo "ECHEC -> ${2^^} N' EXISTE PAS !"
        fi
    else
        echo "ECHEC !"
    fi

# Syntax: ddp update : pour install DDP comme commande systemes
elif [ $1 == "update" ]  ; then
    if [ -e "~/CMD/ddp.exe" ] ; then rm ~/CMD/ddp.exe ; fi
    if [ -e "~/CMD/go.exe" ] ; then rm ~/CMD/go.exe ; fi
    if [ -e "~/CMD/open.exe" ] ; then rm ~/CMD/open.exe ; fi
    cp ~/Projet/ddp/ddp.sh ~/CMD/
    cp ~/Projet/ddp/go.sh ~/CMD/
    cp ~/Projet/ddp/open.sh ~/CMD/
    mv ~/CMD/ddp.sh ~/CMD/ddp.exe
    mv ~/CMD/go.sh ~/CMD/go.exe
    mv ~/CMD/open.sh ~/CMD/open.exe
    echo "SUCCES :)"

# Syntax: ddp code <projet> : pour ouvrire le projet via VSCODE
elif [ "$1" == "code" ] ; then
    cd ~/.ddp/ddp-projet/"$2" 2> /dev/null # pour ce rendre dans la base de donne du projet
    if [ "$?" -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemin du projet dans une variable(rep)
        code "$rep" ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour ouvrire le project avec VSCODE
        if [ "$i" -eq 2 ] ; then
            echo "SUCCES :)"
        else
           echo "ECHEC !"
        fi
    else
        echo "ECHEC !" 
    fi

# Syntax: ddp <projet> -ox | xout : Comilation + execution du projet
elif [ "$2" == "-ox" -o "$2" == "xout" ] ; then # -c pour pour compiler le projet 
    cd ~/.ddp/ddp-projet/$1 2> tmp-$$.txt # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable(execution)
        cd "$rep" 2> tmp-$$.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        $execution # pour executer le projet
        if [ $i -ne 4 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi ; if [ -e "tmp-$$.txt" ] ; then rm tmp-$$.txt ; fi

# Syntax: ddp run | -x <projet> : pour executer le projet
elif [ "$1" == "run" ] || [ "$1" == "-x" ]; then
    cd ~/.ddp/ddp-projet/"$2"/ 2> /dev/null # pour ce rendre dans la base de donne du projet
    if [ "$?" -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $execution # pour executer le projet
        if [ "$i" -ne 3 ] ; then
           echo "ECHEC !"
        fi
    else
        echo "ECHEC !"
    fi

# Syntax: ddp <nom_projet> <chemin_projet> add | new : pour cree un depot du chemin de votre projet
elif [ "$3" == "new" ] || [ "$3" == "add" ] ; then
    cd "$2" 2> tmp-$$.txt
    if [ $? -ne 0 ] ; then
        echo "${2^^} EST INTROUVABLE !"
    else
        i=0
        cd ~/.ddp/ddp-projet ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        mkdir $1 ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        echo "$2" > $1/chemin.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        if [ $i -eq 3 ] ; then
            echo "SUCCES :)"
        else
            echo "ECHEC !"
        fi
    fi 
    if [ -e "tmp-$$.txt" ] ; then rm tmp-$$.txt ; fi

# Syntax : ddp <projet> -o | out : pour compiler le projet
elif [ $2 == "-o" ] || [ $2 == "out" ] ; then # -c pour pour compiler le projet 
    cd ~/.ddp/ddp-projet/$1 2> tmp-$$.txt # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable
        cd "$rep" 2> tmp-$$.txt; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour compiler le projet
        if [ $i -eq 4 ] ; then
            echo "SUCCES :)"
        else
            echo "ECHEC !"
        fi
    else
        echo "ECHEC !"
    fi ; if [ -e "tmp-$$.txt" ] ; then rm tmp-$$.txt ; fi

elif [ "$4" == "new" ] || [ "$4" == "add" ] ; then
    cd "$2" 2> tmp-$$.txt
    if [ $? -ne 0 ] ; then
        echo "$2 EST INTROUVABLE !"
    else
        i=0
        cd ~/.ddp/ddp-projet ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        mkdir $1 ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        echo $2 > $1/chemin.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        echo $3 > $1/execution.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        if [ $i -eq 4 ] ; then
            echo "SUCCES :)"
        else
            echo "ECHEC !"
        fi
    fi ; if [ -e "tmp-$$.txt" ] ; then rm tmp-$$.txt ; fi
else
    manuel | less
fi