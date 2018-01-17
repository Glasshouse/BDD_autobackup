#!/bin/bash

# Configuration de base: datestamp e.g. YYYYMMDD

DATE=$(date +"%Y%m%d")

# Dossier où sauvegarder les backups

BACKUP_DIR="/home/glasshousefr/BACKUP_BDD"

# ID MySQL

MYSQL_USER=""
MYSQL_PASSWORD=""

# Commandes MySQL 

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

# On ignore les bdds useless

SKIPDATABASES="Database|information_schema|performance_schema|mysql"

# Nombre de jours à garder les dossiers (seront effacés après X jours)

RETENTION=28

# ---- NE RIEN MODIFIER SOUS CETTE LIGNE ------------------------------------------

mkdir -p $BACKUP_DIR/$DATE

databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "($SKIPDATABASES)"`

# Export des DBs

for db in $databases; do
echo $db
$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --skip-lock-tables --events --databases $db | gzip > "$BACKUP_DIR/$DATE/$db.sql.gz"
done

# Suppr des dossiers supérieurs à 1 mois

find $BACKUP_DIR/* -mtime +$RETENTION  | xargs rm -rf
