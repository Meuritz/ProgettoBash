#!/bin/bash

#prendo come parametri le dir e le assegno a due variabili
dir1="$1"
dir2="$2"
parametro="$3"

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

#ciclo for per iterare i file della prima dir
#funziona in maniera unidirezionale quindi ciclo i file della prima e non viceversa

case "$parametro" in
    [-R][-r]* )
    
    ;;
    [-I][-i]* )
        for i in "${!files_dir1[@]}"
        do
            #controllo che il file sia un file regolare
            if [[ -f ${files_dir1[i]} ]]; then
                    #controllo che il file sia gia presente, se lo e' controllo se il file che voglio copiare
                    #e' piu' recente del secondo se lo e' lo copio senno vado avanti
                if [[ (${files_dir1[i]} == ${files_dir2[i]}) && (${files_dir1[i]} -nt ${files_dir2[i]}) ]]; then
                    while true; do
                        read -p "Vuoi sovrascrivere il file ${files_dir1[i]} con il file ${files_dir2[i]}? y/n" yesno
                            case $yesno in
                                [Yy]* ) cp "${files_dir1[i]}" "$dir2"; break;;
                                [Nn]* ) break;;
                                    * ) echo "inserisci y(si) o n(no)!!!";;
                            esac
                    done
                fi
                #copio i file che non sono gia presenti
                if [[ ${files_dir1[i]} != ${files_dir2[i]} ]]; then
                    while true; do
                        echo "Vuoi copiare il file ${files_dir1[i]} in $dir2? y/n"
                        read yesno
                            case $yesno in
                                [Yy]* ) cp "${files_dir1[i]}" "$dir2"; break;;
                                [Nn]* ) break;;
                                    * ) echo "inserisci y(si) o n(no)!!!";;
                            esac
                    done
                fi
            fi    
        done

    ;;
    [-IR][-ir][-RI][-ri]* )

    ;;
    *)
    for i in "${!files_dir1[@]}" 
        do
            #controllo che il file sia un file regolare
            if [[ -f ${files_dir1[i]} ]]; then
                #controllo che il file sia gia presente, se lo e' controllo se il file che voglio copiare
                #e' piu' recente del secondo se lo e' lo copio senno vado avanti
                if [[ (${files_dir1[i]} == ${files_dir2[i]}) && (${files_dir1[i]} -nt ${files_dir2[i]}) ]]; then
                    cp "${files_dir1[i]}" "$dir2"
                fi
                #copio i file che non sono gia presenti
                if [[ ${files_dir1[i]} != ${files_dir2[i]} ]]; then
                    cp "${files_dir1[i]}" "$dir2"
                fi
            fi
        done
    ;;
    
esac