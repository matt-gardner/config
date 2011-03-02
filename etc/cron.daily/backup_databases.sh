#!/bin/bash

cp /home/mjg82/studyjournal/db /home/mjg82/backups/studyjournal.db.backup
cp /home/mjg82/language_study/db /home/mjg82/backups/language.db.backup

chown mjg82:aml /home/mjg82/backups/studyjournal.db.backup
chown mjg82:aml /home/mjg82/backups/language.db.backup

