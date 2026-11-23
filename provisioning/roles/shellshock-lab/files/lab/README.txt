SEED Shellshock Attack Lab - CyberRangeCZ
=========================================

Serveur victime (CGI exécuté par un bash vulnérable)
----------------------------------------------------
  http://www.seedlab-shellshock.com/cgi-bin/vul.cgi
  http://www.seedlab-shellshock.com/cgi-bin/getenv.cgi

Depuis la VM, vous êtes l'attaquant. Outils déjà installés : curl, nc.

Exemples (voir l'énoncé pour le détail des tâches) :
  curl http://www.seedlab-shellshock.com/cgi-bin/vul.cgi
  curl -v http://www.seedlab-shellshock.com/cgi-bin/getenv.cgi

Reverse shell (tâche 4)
-----------------------
Mettez-vous en écoute sur la VM, puis déclenchez la connexion depuis le serveur :
  nc -nv -l 9090
L'adresse de l'attaquant (la VM) sur le réseau du conteneur est : 10.9.0.1

Flags
-----
Les flags des tâches 3 et 4 sont dans le conteneur, lisibles par le serveur mais
pas servis par Apache. On ne les obtient qu'en faisant exécuter une commande au
serveur via la vulnérabilité (ils sont dans /var/seed-flags/). Chaque étudiant a
ses propres flags.

Remise à zéro
-------------
Pour repartir d'un conteneur propre (après avoir créé/supprimé des fichiers) :
  sudo reset-shellshock
