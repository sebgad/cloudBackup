# Nextcloud backup scripts
This repository shows bash scripts to complete an daily incremental backup. For using this scripts following packages are necessary to install. With this scripts you are able to make an backup on a nextcloud instance and additional folder paths and databases.

## Requirements
- POSIX bash environment (e.g. Linux)
- [Nextcloud](https://nextcloud.com/) server instance
- [MariaDb](https://mariadb.com/) as backend
- [restic](https://restic.readthedocs.io/en/stable/) repository
- [encpass.sh](https://github.com/plyint/encpass.sh) to hide passwords in bash scripts

## Installation
Please keep the same folder structure like shown in this repository. Following steps are expected as precondition:
- Nextcloud server instance is running
- MariaDb is used and setup as a backend server. It is recommend that a dedicated mariadb user is created to only perform database backups (rights are restricted)
- A restic repository on an external storage device is created
- encpass is installed and the credentials are created

For easier access you can create a symlink for each file, e.g.
```console 
foo@bar:~# ln -s /root/bin/startMultipleBackups /usr/local/bin/startMultipleBackups
```

### Adaptions
All files needs to be adapted to your specific use case. You can find the explanation of the variables in the comments directly in the scripts.

Please make sure to restrict user access of the scripts like below.

```console 
foo@bar:~# chown root startMultipleBackups && chmod 700 startMultipleBackups
``` 
When you want to run the backup script every night, and store the output in a log file, please add the following line in cron
```console 
0 2 * * * startMultipleBackups
0 3 * * * sendCloudBackupLog
0 4 * * * doCloudLogRotation
``` 
