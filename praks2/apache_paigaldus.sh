#!/bin/bash
# Apache paigaldamise ja staatuse kontrolli skript

# Kontrollime, kas apache2 teenus on paigaldatud, kasutades dpkg-query
apache_status=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")

# Kui apache_status on 1, siis apache2 on paigaldatud
if [ "$apache_status" -eq 1 ]; then
    echo "Apache2 on juba paigaldatud."
    
    # Kontrollime apache2 teenuse staatust
    systemctl status apache2 | grep Active

# Kui apache_status ei ole 1, siis apache2 ei ole paigaldatud
else
    echo "Apache2 ei ole paigaldatud. Paigaldan Apache2..."
    
    # Paigaldame apache2 ilma sudo käsuta, kuna oleme root kasutaja
    apt update
    apt install -y apache2
    
    # Kontrollime, kas paigaldamine õnnestus
    if [ $? -eq 0 ]; then
        echo "Apache2 on edukalt paigaldatud."
        
        # Käivitame ja lubame apache2 teenuse automaatse käivitamisega
        systemctl start apache2
        systemctl enable apache2
        
        # Näitame teenuse staatust
        systemctl status apache2 | grep Active
    else
        echo "Apache2 paigaldamine ebaõnnestus."
    fi
fi

