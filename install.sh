#!/bin/bash -e
clear
echo "============================================"
echo "WordPress Install Script by Javier 🤠"
echo "============================================"
echo "⚠️ Iniciar instalación? (y/n)"
read -e run
if [ "$run" == n ] ; then
    exit
else

    echo "Nombre del Proyecto: "
    read -e proyectname

    echo "⚠️ Crear base de dato? (y/n)"
    read -e rundb

    if [ "$rundb" == y ] ; then
        echo "Base de dato nombre: "
        read -e dbname
        cd /Applications/XAMPP/xamppfiles/htdocs/
        /Applications/xampp/xamppfiles/bin/mysql -u root -e "create database $dbname";
        echo "========================="
        echo "Base de dato Creada ✅"
        echo "========================="
    fi

    echo "============================================"
    echo "Un robot está instalando WordPress"
    echo "============================================"
    #crear directorio
    cd /Applications/XAMPP/xamppfiles/htdocs/
    mkdir $proyectname
    cd $proyectname
    #descarga de archivos
    curl -O https://es.wordpress.org/wordpress-4.7.3-es_ES.zip
    tar -zxvf wordpress-4.7.3-es_ES.zip
    #cambiar directorio por defecto
    cd wordpress
    cp -rf . ..
    cd ..
    rm -R wordpress
    #crear wp-config.php
    cp wp-config-sample.php wp-config.php
    #remplazando base de dato
    perl -pi -e "s/database_name_here/root/g" wp-config.php
    perl -pi -e "s/username_here/$dbuser/g" wp-config.php

    perl -i -pe'
    BEGIN {
        @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
        push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
        sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
    }
    s/put your unique phrase here/salt()/ge
    ' wp-config.php

    #crear carpeta y dar permisos
    mkdir wp-content/uploads
    chmod 775 wp-content/uploads
    echo "Cleaning..."
    #borrar instalador
    rm wordpress-4.7.3-es_ES.zip

    echo "⚠️ Requiere instalar Framework ? (y/n)"
    read -e runfr
    #elegir intalar plantilla
    if [ "$runfr" == y ] ; then
        echo "🖥 [1] Framework Wordpress"
        echo "🖥 [2] Framework WooCommerce"
        echo "========================="
        echo "Elegir opcion: "
        read -e runtheme
        if [ "$runtheme" == 1 ] ; then
            rm -rf *
            cd wp-content/themes/
            git clone git@github.com:javierdevcl/Framework-Wordpress.git
            mv Framework-Wordpress $proyectname
        elif [ "$runtheme" == 2 ] ; then
            rm -rf *
            cd wp-content/themes/
            git clone git@github.com:javierdevcl/Framework-Woocomerce.git
            mv Framework-Woocomerce $proyectname
        fi
    fi

    echo "========================="
    echo "Instalación Completa ✅"
    echo "========================="
