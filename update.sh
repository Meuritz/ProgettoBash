#!/bin/bash

#prendo come paremetri le dir e le assegno a due variabili
dir1="$1"
dir2="$2" 

#controllo che i parametri inseriti siano due
if [[ "$#" -ne 2 ]]; then
    echo "inserisci due parametri!!!"
    exit
fi

#usati per debug
#ls "$dir1"
#ls "$dir2"

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
for files in "$dir1"/*
    do
        if [[ $files = "$dir1/""$dir2" ]]; then
            echo "le dir non possono essere una dentro l'altra!!!"
        fi 
    done
for files in "$dir2"/*
    do
        if [[ $files = "$dir2/""$dir1" ]]; then
            echo "le dir non possono essere una dentro l'altra!!!"
        fi 
    done

#assegno  i pathname della prima dir ad un array
for files in "$dir1"/*
    do
        files_dir1[i]="$files"
        ((i++))
    done

#faccio la stessa cosa ma per la seconda dir
for files in "$dir2"/*
    do
        files_dir2[i]="$files"
        ((i++))
    done
#ciclo for per iterare i file della prima dir e della seconda
#funziona in maniera unidirezionale quindi ciclo i file della prima e non viceversa
for i in "${!files_dir1[@]}" 
    do
        #controllo che il file sia gia presente, se lo e' controllo se il file che voglio copiare
        #e' piu' recente del secondo se lo e' lo copio senno vado avanti
        if [[ (${files_dir1[i]} == ${files_dir2[i]}) && (${files_dir1[i]} -nt ${files_dir2[i]}) ]]; then
            cp "${files_dir1[i]}" "$dir2"
        fi
        #copio i file che non sono gia presenti
        if [[ ${files_dir1[i]} != ${files_dir2[i]} ]]; then
            cp "${files_dir1[i]}" "$dir2"
            echo "${files_dir1[i]}"
        fi
    done


#for i in "${files_dir1[@]}"
#    do
#        echo "$i"
#    done
#for i in "${files_dir2[@]}"
#    do
#        echo "$i"
#    done
