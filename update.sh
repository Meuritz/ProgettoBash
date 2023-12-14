#!/bin/bash

#prendo come parametri le dir e le assegno a due variabili
dir1="$1"
dir2="$2"
parametro="$3"

#funzione per copiare
copia(){

    #variabili locali
    source=$1
    destination=$2
    flagR=$3
    flagI=$4

    #ciclo for each per gli elementi presenti
    for files in "$source"/*
    do
        #controllo che il file sia un file regolare
        if [[ -f "$files" ]]; then
            #controllo che il file esista se non esiste lo copio
            if [[ ! (-e "$destination"/"$(basename "$files")") ]]; then
                if [[ $flagI == 1 ]]; then
                    echo "vuoi copirare il $files in $destination ? y/n"
                    read conferma
                    if [[ ("$conferma" == y) || ("$conferma" == Y) ]]; then
                        cp "$files" "$destination"
                    fi
                else
                    cp "$files" "$destination"
                fi
                
            else
                #se il file esiste controllo che quello che voglio copiare sia piu'
                #recente di quello nella destinazione
                if [[ "$files" -nt "$destination"/$(basename "$files") ]]; then
                    if [[ $flagI == 1 ]]; then
                        echo "vuoi copirare il $files in $destination ? y/n"
                        read conferma
                        if [[ ("$conferma" == y) || ("$conferma" == Y) ]]; then
                            cp "$files" "$destination"
                        fi
                    else
                        cp "$files" "$destination"
                    fi
                fi
            fi
        fi
    done
}

#assegno l'output di dirname a due variabili
full_dir1=$(dirname "$dir1")
full_dir2=$(dirname "$dir2")

#controllo che i parametri inseriti siano due
if [[ "$#" -lt 2 ]]; then
    echo "inserisci due parametri!!!"
    exit
fi

#controlla che i due parametri siano directory "/home/cristiano/Desktop/Bash/dirA"
if [[ (! -d "$dir1") || (! -d "$dir2") ]]; then
    echo "inserisci due directory!!!"
    exit
fi

#controllo che non siano link simbolici
if [[ (-L "$dir1") || (-L "$dir2") ]]; then
    echo "una o tutte e due le dir sono link simbolici uscita in corso..."
    sleep 3
    exit
fi

#controllo che le directory non siano una dentro l'altra
if [[ ("$dir2" == "$dir1"/*) || ("$dir1" == "$dir2"/*) ]]; then
    echo "le dir sono una dentro l'altra!!!"
    exit
fi

#controllo che le directory siano allo stesso livello
if [[ "$full_dir1" != "$full_dir2" ]]; then
    echo "le dir non sono allo stesso livello!!!"
    exit
fi

#ciclo for per iterare i file della prima dir
#funziona in maniera unidirezionale quindi ciclo i file della prima e non viceversa

case "$parametro" in
    [-R][-r]* )

    ;;

    [-I][-i]* )
    #chiamo la funzione copia con la conferma
    copia "$dir1" "$dir2" "" "1"
    ;;

    [-IR][-ir][-RI][-ri]* )

    ;;

    *)
    #chiamo la funzione copia
    copia "$dir1" "$dir2"
    ;;
    
esac