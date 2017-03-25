#!/bin/bash -e
clear
echo "============================================"
echo "WordPress Install Script by Javier 🤠"
echo "============================================"
read -p "Iniciar instalación? (y/n)" -n 1 -r
read -e run
if [[  $REPLY =~ ^[Nn]$ ]]; then
    exit
else
    echo -e "\033[35m * Nombre del Proyecto: \033[0m "
    read -e proyectname
    echo -e "\033[35m * Crear base de dato? (y/n)\033[0m"
    read -e rundb

    if [ "$rundb" == y ] ; then
        echo -ne '\n'
        echo -e "\033[35m * Base de dato nombre: \033[0m"
        read -e dbname
        cd /Applications/XAMPP/xamppfiles/htdocs/
        /Applications/xampp/xamppfiles/bin/mysql -u root -e "create database $dbname";
        echo -ne '\n'
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
    #wp core
    wp core config --dbname=$dbname --dbuser=root --locale=es_ES
    wp core install --url=localhost/$proyectname/ --title=Example --admin_user=admin --admin_password=pass --admin_email=wordpress@javierdev.cl

    read -p "Iniciar instalación? (y/n)" -n 1 -r
    #elegir intalar plantilla
    if [[  $REPLY =~ ^[Yy]$ ]]; then
        echo "[1] Framework WordPress"
        echo "[2] Framework WooCommerce"
        echo "========================="
        echo "Elegir opcion: "
        read -e runtheme
        if [ "$runtheme" == 1 ] ; then
            cd /Applications/XAMPP/xamppfiles/htdocs/$proyectname/wp-content/themes/
            rm -rf *
            git clone git@github.com:javierdevcl/Framework-Wordpress.git
            mv Framework-Wordpress $proyectname
        elif [ "$runtheme" == 2 ] ; then
            cd /Applications/XAMPP/xamppfiles/htdocs/$proyectname/wp-content/themes/
            rm -rf *
            git clone git@github.com:javierdevcl/Framework-Woocomerce.git
            mv Framework-Woocomerce $proyectname
        fi
    fi

    echo "========================="
    echo "Instalación Completa ✅"
    echo "========================="
fi
exit
