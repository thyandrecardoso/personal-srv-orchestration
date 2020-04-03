#!/usr/bin/env sh

/home/thyandrecardoso/bin/borg_backup_custom.sh / /mnt/backups/wall-e__root /home/thyandrecardoso/bin/borg_root_exclude.txt && /home/thyandrecardoso/bin/borg_backup_custom.sh /mnt/data /mnt/backups/wall-e__data /home/thyandrecardoso/bin/borg_data_exclude.txt
