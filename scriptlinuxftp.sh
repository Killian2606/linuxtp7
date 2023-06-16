
# Paramètres de connexion SFTP
sftp_host="13.38.122.135"
sftp_user="ubuntu"
sftp_private_key="/home/ubuntu/maclefprive.pem"

# Chemin du répertoire source à transférer
read -p "Chemin du répertoire source : " source_directory

# Vérifier si le répertoire source existe
if [ ! -d "$source_directory" ]; then
    echo "Le répertoire source $source_directory n'existe pas."
    exit 1
fi

# Chemin de destination pour le transfert du répertoire
read -p "Chemin de destination : " target_directory

# Transfert du répertoire via SCP avec journalisation
log_file="scp_$(date +'%Y%m%d_%H%M%S').log" # Fichier de log avec date et heure actuelles
{
    echo "Date et heure du transfert : $(date +'%Y-%m-%d %H:%M:%S')"
    echo "Répertoire source : $source_directory"
    echo "Chemin de destination : $target_directory"
    echo "----------------------------"
} > $log_file

scp -i $sftp_private_key -r $source_directory $sftp_user@$sftp_host:$target_directory >> $log_file 2>&1

# Vérification si le transfert s'est bien déroulé
if [ $? -eq 0 ]; then
    echo "Le répertoire $source_directory a été transféré avec succès vers $target_directory."
else
    echo "Erreur lors du transfert du répertoire."
fi

# Affichage du contenu du fichier de log
echo "Contenu du fichier de log ($log_file) :"
cat $log_file

# Fin du script
echo "Tâche terminée."
