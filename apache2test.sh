#!/bin/bash
SERVICE="apache2"
# Kontrolli, kas teenus on olemas
if systemctl list-unit-files | grep -q "${SERVICE}.service"; then
    echo "Teenuse '$SERVICE' olemasolu: LEITUD"
    # Kontrolli, kas teenus töötab
    if systemctl is-active --quiet $SERVICE; then
        echo "Teenuse '$SERVICE' staatus: TÖÖTAB"
    else
        echo "Teenuse '$SERVICE' staatus: EI TÖÖTA"
    fi
else
    echo "Teenuse '$SERVICE' olemasolu: PUUDUB"
fi
