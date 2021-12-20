# Backup scripts for nextcloud
With this repository I want to share my backup scripts for a nextcloud based homecloud. The file [BackupCloudSystem](BackupCloudSystem) needs to be placed in /usr/bin folder. Please make sure you run the following line that only root can access and read the file for security reasons.
```console 
foo@bar:~# chown root BackupCloudSystem && chmod 700 BackupCloudSystem
``` 
When you want to run the backup script every night, please add the following line in cron
```console 
@midnight BackupCloudSystem
``` 

## Requirements
- Linux distribution
- [Nextcloud](https://nextcloud.com/) server instance
- [Maria-db](https://mariadb.com/) as backend
- Existing [restic](https://restic.readthedocs.io/en/stable/) repository
