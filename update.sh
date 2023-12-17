#!/bin/bash

#prendo come parametri le dir e le assegno a due variabili
dir1="$1"
dir2="$2"
parametro="$3"

#funzione per copiare
copia(){

    #variabili locali
    source="$1"
    destination="$2"
    flagR="$3"
    flagI="$4"

    #ciclo for each per gli elementi presenti
    for files in "$source"/*
    do
        #controllo che il file sia un file regolare
        if [[ -f "$files" ]]; then
            #controllo che il file esista se non esiste lo copio
            if [[ ! (-e "$destination"/"$(basename "$files")") ]]; then
                #opzione conferma( solo se il flagI è uguale a 1)
                if [[ $flagI == 1 ]]; then
                     while true; do
                            echo "Vuoi copiare il file $files in $destination? y/n"
                            read conferma
                                case $conferma in
                                    [Yy]* ) cp "$files" "$destination"; break;;
                                    [Nn]* ) break;;
                                        * ) echo "inserisci y(si) o n(no)!!!";;
                                esac
                        done
                else
                #se la flag non è uguale a 1, copia senza chiedere conferma
                    cp "$files" "$destination"
                fi
            else
                #se il file esiste controllo che quello che voglio copiare sia piu'
                #recente di quello nella destinazione, se lo e' lo copio
                if [[ "$files" -nt "$destination"/$(basename "$files") ]]; then
                    #opzione conferma( solo se il flagI è uguale a 1)
                    if [[ $flagI == 1 ]]; then
                        while true; do
                            echo "Vuoi copiare il file $files in $destination? y/n"
                            read conferma
                                case $conferma in
                                    [Yy]* ) cp "$files" "$destination"; break;;
                                    [Nn]* ) break;;
                                        * ) echo "inserisci y(si) o n(no)!!!";;
                                esac
                        done
                    else
                        #se la flagI non è uguale a 1, copia senza chiedere conferma
                        cp "$files" "$destination"
                    fi
                fi
            fi
        fi
        #parte ricorsiva se la flagR è uguale a 1
        if [[ (-d "$files") && ("$flagR" == 1) ]]; then
            #controllo che la cartella non esista gia nella destinazione
            #se esiste copio i file richiamando la funzione "copia"
            if [[ -e "$destination"/"$(basename "$files")" ]]; then
                copia "$source"/"$(basename "$files")" "$destination"/"$(basename "$files")" "$flagR" "$flagI"
            else
            #se la cartella non esiste nella destinazione la creo
            #poi richiamo la funzione "copia"
                mkdir "$destination"/"$(basename "$files")"
                copia "$source"/"$(basename "$files")" "$destination"/"$(basename "$files")" "$flagR" "$flagI"
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

#switch case per le opzioni -r -i
case "$parametro" in
    #chiamo la funzione in maniera ricorsiva
    [-R][-r] )
    copia "$dir1" "$dir2" "1" "0"; echo "test r"
    ;;
    
    #chiamo la funzione copia con la conferma
    [-I][-i] )
    copia "$dir1" "$dir2" "0" "1"; echo "test i"
    ;;
    
    #chiamo la funzione con il prompt e la ricorsivita'
    -[Rr][Ii]* )
    copia "$dir1" "$dir2" "1" "1"; echo "test ri"
    ;;

    #chiamo la funzione base
    *)
    copia "$dir1" "$dir2" "0" "0"
    ;;
    
esac