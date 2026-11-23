#!/bin/bash
# Écrit les flags de la sandbox dans le conteneur, puis lance Apache.
#
# Les flags sont lisibles par www-data (l'utilisateur sous lequel tourne le CGI),
# mais hors de la racine web : Apache ne les sert pas. Depuis la VM, l'étudiant n'a
# ni docker ni sudo, donc il ne peut pas les lire directement. Le seul chemin est
# de faire exécuter une commande au serveur via la vulnérabilité (lecture du fichier).
set -e

mkdir -p /var/seed-flags
printf '%s\n' "${SEED_FLAG_TASK3:-LocalShellTask3}" > /var/seed-flags/task3
printf '%s\n' "${SEED_FLAG_TASK4:-LocalShellTask4}" > /var/seed-flags/task4
chown -R www-data:www-data /var/seed-flags
chmod 0711 /var/seed-flags
chmod 0400 /var/seed-flags/task3 /var/seed-flags/task4

service apache2 start
exec tail -f /dev/null
