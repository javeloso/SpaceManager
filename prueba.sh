#!/bin/bash

# Mostrar un menú de selección simple con dialog
opcion=$(dialog --inputmenu "Selecciona una opción:" 10 50 2 \
        1 "Opción 1" \
        2 "Opción 2" \
        3>&1 1>&2 2>&3)

# Verificar la selección del usuario y mostrar el texto correspondiente
case "$opcion" in
    1)
        echo "Has seleccionado la Opción 1"
        ;;
    2)
        echo "Has seleccionado la Opción 2"
        ;;
    *)
        echo "Selección inválida"
        ;;
esac

case "$opcion" in
    1)
        echo "Has seleccionado la Opción 1"
        ;;
    2)
        echo "Has seleccionado la Opción 2"
        ;;
    *)
        echo "Selección inválida"
        ;;
esac

# Listar todos los archivos del actual directorio
echo "Listar todos los archivos del actual directorio"

#ls -p | grep -v /

printf "\r\nDIRECTORIOS: \r\n"

directories=()
while IFS= read -r -d '' dir; do
    if [ -d "$file" ]; then
        directories+=("$dir")
    fi
done < <(find . -maxdepth 1 -type d -print0)
printf "\r\nARCHIVOS: \r\n"

for file in *; do
    if [ -f "$file" ]; then
        echo "$(du -sh "$file") - $file"
    fi
done

options=("Opción 1" "Opción 2" "Salir")

# Mostrar el menú de selección
selection=$(dialog --clear --backtitle "Selecciona una opción" --menu "Usa las flechas y Enter para seleccionar:" 15 50 4 "${options[@]}" 2>&1 >/dev/tty)

# Realizar acciones basadas en la selección
case "$selection" in
    "Opción 1")
        echo "Has seleccionado la Opción 1"
        ;;
    "Opción 2")
        echo "Has seleccionado la Opción 2"
        ;;
    "Salir")
        echo "Saliendo..."
        ;;
    *)
        echo "Opción inválida"
        ;;
esac
