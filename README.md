# SEED Shellshock Attack — scénario CyberRangeCZ

Adaptation CyberRangeCZ du SEED Lab **« Shellshock Attack »** : exploiter la
vulnérabilité Shellshock (CVE-2014-6271) d'un bash via un programme CGI Apache,
pour exécuter des commandes à distance sur un serveur, puis obtenir un *reverse
shell*. Une seule VM ; **flags uniques par étudiant** pour les tâches d'exploitation.

## Architecture

```
[ seed ] 10.1.29.10 ── lab-switch 10.1.29.0/24 ── 10.1.29.1 [ router ] ── WAN (build au provisioning)
   │
   └─ bridge Docker net-10.9.0.0 (10.9.0.0/24, interne à la VM)
         passerelle 10.9.0.1 = la VM (attaquant)
         conteneur victime 10.9.0.80 = www.seedlab-shellshock.com (Apache + CGI bash vulnérable)
```

| Élément | Rôle |
|-|-|
| VM `seed` (image `seed`) | poste de l'étudiant : navigateur, `curl`, `nc`, et la pile Docker |
| conteneur `victim-10.9.0.80` | serveur victime SEED (bash volontairement vulnérable) |

Le conteneur reste sur le bridge Docker **interne à la VM** : il n'est jamais exposé
sur le réseau de la sandbox. La VM est la passerelle du bridge (10.9.0.1), ce qui
permet le reverse shell de la tâche 4 (le serveur se reconnecte à la VM).

## Comptes

| Compte | Qui l'utilise | Droits |
|-|-|-|
| `ubuntu` (`mgmt_user`) | la plateforme (Ansible, clé SSH) | sudo |
| `seed` / `dees` | l'étudiant (console *Open GUI* ou SSH) | **pas de sudo**, **pas dans le groupe docker** ; seule exception : `sudo reset-shellshock` |

L'étudiant n'a pas accès à Docker : il ne peut pas lire les flags directement dans le
conteneur. Le seul chemin est l'attaque elle-même.

## Les flags

Les flags des tâches 3 et 4 sont écrits dans le conteneur (`/var/seed-flags/`),
lisibles par le serveur mais **non servis par Apache**. On ne les obtient qu'en
faisant exécuter une commande au serveur via la vulnérabilité Shellshock. Ils sont
**uniques par sandbox** (`variables.yml`). Les tâches 1 et 2 sont des tâches de
connaissance (réponse identique pour tous).

## Déployer sur CyberRangeCZ

Même procédure que les autres TP :

1. **Sandboxes > Images** : vérifier que `seed` et `debian-12-x86_64` existent.
2. **Sandboxes > Definition** : *Create*, URL Git de ce dépôt, révision `main`.
3. **Sandboxes > Pool** : *Create* (taille 1 pour tester), puis *Allocate*.
4. **Trainings > Definition** : *Upload* de `training.json`.
5. **Trainings > Instance** puis **Run** (jeton d'accès `start`).

Le provisioning nécessite Internet (build de l'image Docker) ; le routeur le fournit.

## Vérifier une sandbox déployée

Sur `seed` (connexion `seed` / `dees`) :

```bash
curl http://www.seedlab-shellshock.com/cgi-bin/vul.cgi      # -> Hello World
curl -v http://www.seedlab-shellshock.com/cgi-bin/getenv.cgi
```

## Arborescence

```
library-shellshock/
├── topology.yml                 1 VM + routeur, réseau 10.1.29.0/24
├── variables.yml                flag_task3, flag_task4 (1 par sandbox)
├── training.json                7 niveaux (intro, accès, tâches 1-4, fin)
└── provisioning/
    ├── requirements.yml         user-access, sandbox-logging
    ├── playbook.yml
    └── roles/
        ├── hosts/               docker, curl, nc
        └── shellshock-lab/      conteneur victime + compte étudiant + durcissement
            └── files/Labsetup/  sources SEED (voir ATTRIBUTION.txt)
```
