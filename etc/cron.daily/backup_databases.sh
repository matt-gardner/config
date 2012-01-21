#!/bin/bash

cp /home/matt/studyjournal/db /media/backup_disk/databases/studyjournal.db
cp /home/matt/language_study/db /media/backup_disk/databases/language.db

chown matt:matt /media/backup_disk/databases/studyjournal.db
chown matt:matt /media/backup_disk/databases/language.db

