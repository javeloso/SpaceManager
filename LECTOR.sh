#!/bin/bash
# LECTOR.sh

opcion=0
directorios=()
tamanoDirectorios=()
archivos=()
tamanoArchivos=()
total=0
mensaje="listar" 
show=0
yesNo=0

function carga(){
    local directorioActual=$1

    opcion=0
    directorios=()
    tamanoDirectorios=()
    archivos=()
    tamanoArchivos=()
    total=0

    cd "$directorioActual" || exit

    numArchivos=0
    numdirectories=0

    for file in "$directorioActual"/*; do
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
    clear
    echo $XDG_DATA_HOME
    echo "Listar todos los archivos del actual directorio"
    echo $mensaje

    showFiles
    showdirectories

    echo ""

    
    if [ $opcion -eq $total ]; then
        echo -e "\e[30;47mAtras\e[0m"
    else
        echo "Atras"
    fi
    if [ $opcion -eq $((total + 1)) ]; then
        echo -e "\e[30;47mSalir\e[0m"
    else
        echo "Salir"
    fi

}

function reloaddirectories(){
    printf "\033[1;1H"
}

function showCurrent(){
    clear
    echo "¿QUIERES ELIMINAR EL ARCHIVO ${archivos[$1]} ${tamanoArchivos[$1]}"
    if [ $yesNo -le 0 ]; then
        echo -e "\e[30;47mNO\e[0m"
        yesNo=0
    else
        echo "NO"
    fi
    if [ $yesNo -ge 1 ]; then
        echo -e "\e[30;47mSI\e[0m"
        yesNo=1;
    else
        echo "SI"
    fi
}

# Listar todos los archivos del actual directorio
printf "\e[?25l" # Ocultar cursor
carga "$PWD"
clear
mostrar


while true; do
    read -rsn3 key

    if [[ $key == $'\e[A' ]]; then
        if [ $show -eq 0 ]; then
            if [ $opcion -le 0 ]; then
                opcion=$((total + 1))
            else
                ((opcion -= 1))
            fi
        else 
            ((yesNo -= 1))
        fi
    elif [[ $key == $'\e[B' ]]; then
        if [ $show -eq 0 ]; then
            if [ $opcion -ge $((total + 1)) ]; then
                opcion=0
            else
                ((opcion += 1))
            fi
        else 
            ((yesNo += 1))
        fi
    elif [[ $key == $'' && $opcion -ge $((total + 1)) ]]; then
        printf "\e[?25h" # Mostrar cursor
        break  # Salir del bucle si se presiona Enter y opcion es igual o mayor que el total
    elif [[ $key == $'' && $opcion -eq $total ]]; then
        carga $(dirname "$PWD")
        mostrar
    elif [[ $key == $'' ]]; then
        if [ $show -eq 0 ]; then
            if [ $opcion -lt ${#archivos[@]} ]; then
                #showCurrent ${archivos[$opcion]}
                yesNo=0
                mensaje="¿QUIERES ELIMINAR EL ARCHIVO ${archivos[$opcion]}?"
                show=1
            elif [ $opcion -gt $((${#archivos[@]} - 1)) ]; then
                indice_directorio=$((opcion - ${#archivos[@]}))

                if [ $indice_directorio -lt ${#directorios[@]} ]; then
                    mensaje="${directorios[$indice_directorio]}"
                    carga "${directorios[$indice_directorio]}"
                    mostrar
                fi
            fi
        else 
            if [ $yesNo -eq 0 ]; then
                show=0
                mensaje="listar"
            else 
                rm "${archivos[$opcion]}" ~/Trash/
                carga "$PWD"
                mostrar
                show=0
                mensaje="listar"
            fi
        fi
    fi

    if [ $show -eq 0 ]; then
        reloaddirectories
        mostrar
    else 
        showCurrent $opcion
    fi
done