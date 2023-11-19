#!/bin/bash
# LECTOR.sh

opcion=0
directorios=()
tamanoDirectorios=()
archivos=()
tamanoArchivos=()
total=0

function carga(){
    numArchivos=0
    numdirectories=0
    for file in *; do
        if [ -d "$file" ]; then
            directorios[$numdirectories]="$file"
            tamanoDirectorios[$numdirectories]=$(du -sh "$file" | awk '{print $1}')
            ((numdirectories += 1))
            
        elif [ -f "$file" ]; then
            archivos[$numArchivos]="$file"
            tamanoArchivos[$numArchivos]=$(du -sh "$file" | awk '{print $1}')
            ((numArchivos += 1))
        fi
    done
    total=$((${#archivos[@]} + ${#directorios[@]}))
}

function showdirectories(){
    printf "\r\nDIRECTORIOS: \r\n"

    directories=()
    opcionBucle="${#archivos[@]}"

    for ((i=0; i<"${#directorios[@]}"; i++)); do
        file="${directorios[$i]}"
            size="${tamanoDirectorios[$i]}"
            if [ $opcionBucle -eq $opcion ]; then
                printf "\e[30;47m%s\t%s\e[0m\n" "$size" "$file"
            else
                echo -e "$size\t$file"

            fi
            ((opcionBucle += 1))
    done
}

function showFiles(){
    printf "\r\nARCHIVOS: \r\n"
    opcionBucle=0
    for ((i=0; i<"${#archivos[@]}"; i++)); do
        file="${archivos[$i]}"
            size="${tamanoArchivos[$i]}"
            if [ $opcionBucle -eq $opcion ]; then
                printf "\e[30;47m%s\t%s\e[0m\n" "$size" "$file"
            else
                echo -e "$size\t$file"

            fi
            ((opcionBucle += 1))
    done
}

function mostrar(){

    if [ $opcion -lt 0 ]; then
        opcion=0
    fi
    echo "Listar todos los archivos del actual directorio"
    echo "Presione la tecla 'q' para salir"

    showFiles
    showdirectories

    echo ""

    
    if [ $opcion -ge $total ]; then
        echo -e "\e[30;47mSalir\e[0m"
        opcion=$total
    else
        echo "Salir"
    fi
}

function reloaddirectories(){
    printf "\033[1;1H"
}

# Listar todos los archivos del actual directorio
clear
printf "\e[?25l" # Ocultar cursor
carga
mostrar


while true; do
    read -rsn3 key

    if [[ $key == $'\e[A' ]]; then
        ((opcion -= 1))
    elif [[ $key == $'\e[B' ]]; then
        ((opcion += 1))
    elif [[ $key == $'' && $opcion -ge $total ]]; then
        printf "\e[?25h" # Mostrar cursor
        break  # Salir del bucle si se presiona Enter y opcion es igual o mayor que el total
    fi

    reloaddirectories
    mostrar
done






