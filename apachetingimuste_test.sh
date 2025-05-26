#!/bin/bash


echo "----- Test 1: Faili olemasolu kontroll (/var/www/html/index.html) -----"
if [ -f /var/www/html/index.html ]; then
    echo "OK: Fail eksisteerib."
else
    echo "VIGA: Fail puudub!"
fi


echo "----- Test 2: Teenuse apache2 staatus -----"
if systemctl is-active --quiet apache2; then
    echo "OK: apache2 teenus töötab."
else
    echo "VIGA: apache2 teenus ei tööta!"
fi


echo "----- Test 3: Omanikukontroll kataloogis /var/www/html -----"
for fail in /var/www/html/*; do
    if [ -f "$fail" ]; then
        omanik=$(stat -c "%U" "$fail")
        if [[ "$omanik" == "root" || "$omanik" == "www-data" ]]; then
            echo "OK: $fail omanik on $omanik"
        else
            echo "VIGA: $fail omanik on $omanik (ootasime root või www-data)"
        fi
    fi
done
