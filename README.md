TheCliPanel est un outil en ligne de commande destiné à vous simplifier l’installation et la configuration de services essentiels sur un serveur Linux. Grâce à une interface en mode texte intuitive, vous pouvez déployer rapidement un environnement web, FTP ou SSH sans passer par des procédures manuelles fastidieuses.

Pensé comme un tableau de bord interactif, ce script automatise les étapes clés de l’administration système tout en vous laissant le contrôle sur les choix importants.

Ce que vous pouvez faire avec TheCliPanel
Installer Apache2, PHP, MariaDB et configurer un hôte virtuel sécurisé

Ajouter des utilisateurs SQL avec gestion des privilèges via une interface interactive

Déployer rapidement des CMS et outils comme :

WordPress, Joomla, MediaWiki, Moodle

GLPI, Dolibarr, DokuWiki

Mettre en place un serveur FTP sécurisé avec Pure-FTPD et gestion des utilisateurs virtuels

Sécuriser votre serveur SSH : changement de port, nombre de tentatives limité, désactivation de la connexion root

Visualiser les ports ouverts, consulter les journaux FTP, surveiller les connexions actives

Planifier des mises à jour automatiques du système via crontab

Pourquoi utiliser TheCliPanel
Ce script est idéal si vous cherchez à :

Gagner du temps lors de l’installation d’un environnement serveur complet

Mettre en place un serveur web ou de test sans vous perdre dans les configurations manuelles

Disposer d’un outil pédagogique pour comprendre comment fonctionnent les services web, FTP ou SQL

Centraliser vos installations dans une seule interface simple d’utilisation

Comment l'utiliser :
après l'in,stallation du fichier :
chmod +x TheCliPanel.sh
sudo ./TheCliPanel.sh

Le menu vous guidera à chaque étape, en fonction des services que vous souhaitez mettre en place.

Points à garder à l’esprit
Ce script effectue des modifications sur des fichiers système critiques (Apache, SSH, MariaDB, etc.)

Il est recommandé de l’utiliser dans un environnement de test ou maîtrisé

Certaines parties du code sont encore en cours d’amélioration (notamment la configuration de Fail2Ban)

Prévu pour les distributions basées sur Debian (Debian, Ubuntu)

Licence
Le script peut être librement utilisé, modifié ou adapté à vos besoins. Vous pouvez l’intégrer à vos projets selon la licence de votre choix (MIT, GPL, etc.).
