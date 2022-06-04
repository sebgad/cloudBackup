!/bin/bash

# using encpass.sh from https://github.com/plyint/encpass.sh to hide password in shell script
. encpass.sh

# MariaDB settings
MARIA_DB_HOST=localhost
# MariaDB backup user
MARIA_DB_USER=backupuser
# MariaDB password for backup user
MARIA_DB_PW=$(get_secret Bucket mysql_user)
# Array with database names for restic backup
MARIA_DB_NAMES=(database1 database2)
