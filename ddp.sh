#!/bin/bash
# Le manuel de Derkariom depot des projet(DDP)
manuel()
{
    clear
    echo -e "\n\nLEGANT: OU(|) ET(&)\n"
    echo -e "\n\nddp -v | --version -> POUR AFFICHER LA VERSION DE DDP\n"
    echo -e "ddp new | add -> POUR AJOUTER UN NOUVEAU PROJET\n"
    echo -e "ddp add <nom_projet> <chemin_projet>  -> POUR CREER UN DEPOT DU CHEMIN DE VOTRE PROJET\n"
    echo -e "ddp add <nom_projet> <chemin_projet> <code_compiler> <code_execution>  -> POUR CREER UN DEPOT DE VOTRE PROJET\n"
    echo -e "ddp log -> POUR LISTER LES PROJETS SUR DDP\n"
    echo -e "ddp del <nom_projet> -> POUR SUPPRIMER UN PROJET\n"
    echo -e "ddp code <projet> -> POUR OUVRIR LE PROJET AVEC VSCODE\n"
    echo -e "ddp run <projet> -> POUR EXECUTER UN PROJET\n"
    echo -e "ddp out <nom_projet> -> POUR COMPILER VOTRE PROJET\n"
    echo -e "ddp xout <nom_projet> -> POUR COMPILER ET EXECUTER VOTRE PROJET\n"
    echo -e "ddp projet -o -> POUR COMPILER UN PROJET\n"
    echo -e "ddp projet -ox -> POUR COMPILER ET EXECUTER VOTRE PROJET\n"
}
declare -i k
declare -i i
repa=$(pwd) # pour sauvegarde le repertoir actuelle avant l' appelle de la commande
cd ~/      # pour ce rendre au repertoire utilisateurs

grep go ~/.bashrc >> /dev/null
if [ "$?" != 0 ] ; then
    echo "alias go='. go'" >> .bashrc
fi

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
    manuel | less

# -v pour voir la version de Derkariom depot de projet (DDP)
elif [ "$1" = "-v" -o "$1" == "--version" ] ; then
    echo "DERKARIOM DEPOT DES PROJETS VERSION 1.9 BETA :)"

# pour visiter le manuel de Derkariom depot des projets (DDP)
elif [ "$1" == "-h" -o "$1" == "--help" ] ; then
    manuel | less

# Syntax: ddp new | add : pour cree un nouveau projet
elif [ "$1" == "new" -o "$1" == "add" -a "$#" == 1 ] ; then
# "new" est une variable qui stock le nom du projet
# "chemin" est une variable qui stock le chemin du repertoire du projet
# "compiler" est une variable qui stock le code de compilation du projet
# "execution" est une variable qui stock le code d'execution du projet   
clear

# Saisie du nom du projet
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

# Saisie du chemin absolu du projet
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

# Saisie du code de compilation
read -p "CODE DE CONPILATION : " compiler

# Saisie du code d' execution
read -p "CODE D' EXECUTION : " execution

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

# Syntax: ddp log : pour lister tout les depots
elif [ "$1" == "log" -a "$#" -eq 1 ] ; then
    cd ~/.ddp/ddp-projet 2> /dev/null
    if [ "$?" -eq 0 ] ; then
        echo -e "\t\tLISTE DES PROJETS\n"
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
elif [ "$1" == "del" -o "$1" == "drop" -a "$#" -eq 2 ] ; then
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

# Syntax: ddp code <projet> : pour ouvrire le projet via VSCODE
elif [ "$1" == "open" ] ; then
    cd ~/.ddp/ddp-projet/"$2" 2> /dev/null # pour ce rendre dans la base de donne du projet
    if [ "$?" -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemin du projet dans une variable(rep)
        open "$rep" ; if [ "$?" -eq 0 ] ; then i=i+1 ; fi # pour ouvrire le project avec VSCODE
        if [ "$i" -eq 2 ] ; then
            echo "SUCCES :)"
        else
           echo "ECHEC !"
        fi
    else
        echo "ECHEC !" 
    fi

# Syntax: ddp out <projet> : pour compiler un projet
elif [ "$1" == "out" ] ; then
    cd ~/.ddp/ddp-projet/"$2" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        if [ $i -ne 3 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi

# Syntax: ddp out <projet> : pour compiler & executer un projet
elif [ "$1" == "xout" ] ; then
    cd ~/.ddp/ddp-projet/"$2" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable(execution)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        $execution # pour executer le projet
        if [ "$i" -ne 4 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi

# Syntax: ddp <projet> -o : pour compiler un projet
elif [ "$2" == "-o" ] ; then
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        if [ $i -ne 3 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi

# Syntax: ddp <projet> -ox | xout : pour compiler & execution un projet
elif [ "$2" == "-ox" ] ; then 
    cd ~/.ddp/ddp-projet/"$1" 2> /dev/null # pour ce rendre dans le repertoire de basse de donne du projet
    if [ $? -eq 0 ] ; then
        i=0
        rep=$(cat chemin.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le chemain du projet dans une variable(rep)
        compiler=$(cat compiler.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code de conpilation dans une variable(compiler)
        execution=$(cat execution.txt) ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour stoker le code d' execution dans une variable(execution)
        cd "$rep" 2> /dev/null ; if [ $? -eq 0 ] ; then i=i+1 ; fi # pour ce rendre dans le repertoire du projet
        $compiler # pour compiler le projet
        $execution # pour executer le projet
        if [ $i -ne 4 ] ; then
            echo "ECHEC !"
        fi 
    else
        echo "ECHEC !"
    fi

# Syntax: ddp run <projet> : pour executer le projet
elif [ "$1" == "run" ] ; then
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

# Syntax: ddp add <nom> <chemin> : pour cree un depot du chemin de votre projet
elif [ "$1" == "new" -o "$1" == "add" -a "$#" == 3 ] ; then
    if [ "$3" == "." ] ; then
        c=$repa
    else
        c=$3
    fi
    cd "$c" 2> /dev/null
    if [ "$?" -ne 0 ] ; then
        echo "${2^^} EST INTROUVABLE !"
    else
        i=0
        cd ~/.ddp/ddp-projet ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        mkdir "$2" 2> /dev/null ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        echo "$c" > $2/chemin.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        if [ $i -ne 3 ] ; then
            echo "ECHEC ! : CE PROJET EXISTE DEJA"
        fi
    fi 

# Syntax: ddp add <nom> <chemin> : pour cree un depot du chemin de votre projet
elif [ "$1" == "new" -o "$1" == "add" -a "$#" -eq 5 ] ; then
    if [ "$3" == "." ] ; then
        c=$repa
    else
        c=$3
    fi
    cd "$c" 2> /dev/null
    if [ "$?" -ne 0 ] ; then
        echo "$3 EST INTROUVABLE !"
    else
        i=0
        cd ~/.ddp/ddp-projet ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        mkdir "$2" ; if [ $? -eq 0 ] ; then i=$i+1 ; fi
        echo "$c" > $2/chemin.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        echo "$4" > $2/compiler.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        echo "$5" > $2/execution.txt ; if [ $? -eq 0 ] ; then i=i+1 ; fi
        if [ $i -ne 5 ] ; then
            echo "ECHEC !"
        fi
    fi
else
    manuel | less
fi