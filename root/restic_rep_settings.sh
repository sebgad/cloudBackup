#!/bin/bash

# using encpass from https://github.com/plyint/encpass.sh to hide password in shell script
. encpass.sh

# define Restic Repository settings
export RESTIC_REPOSITORY=/srv/restic/backuprepo
export RESTIC_PASSWORD=$(get_secret Bucket secretkey)

# define array with backup locations for restic
BACKUPDIRS=( /var/www/nextcloud
             /var/nextcloud-data
           )
