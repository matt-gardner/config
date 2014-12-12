#!/usr/bin/python
#
# Andrew's notes:
#
# Note that when you make a new disk, you need to run fdisk and create a
# single partition of type 83 (Linux).  Then do the following:
# mkfs.ext3 -i 262144 -m 0 -L AMCNABB_BACKUP /dev/sdX1
# tune2fs -c 0 /dev/sdX1
# Note that to copy from an old backup disk to a new one, you must do the
# following to preserve hard links (which is very important):
# rsync -aH /mnt/backup/ /mnt/backup2
#
# I just ran a format from the disk utility in system tools, and it seems to
# have worked just fine.
#
# The -i in the mkfs command says how many inodes to make; Andrew says that
# inodes could fill up fast with the way we're doing this backup.
# df -i : tells you how many inodes you're using

MOUNTPOINT = "/run/media/matt/backup_disk"
DEVICE = "LABEL=backup_disk"


WINDOWS = '/run/media/matt/OS/Users/Sabrina/'
PATHS = [WINDOWS+'Documents/Scores', WINDOWS+'Pictures', WINDOWS+'Music',
        WINDOWS+'Videos', '/home']
# exclusion: DON'T PUT SPACES IN PATHS (use "?" instead of " " in paths)!
EXCLUDES = ['Documents/Downloads', '/home/matt/.cache', '/home/lost+found',
        '/home/matt/.thumbnails']

##############################################################################

import glob
import os
from subprocess import call
import sys
import time

def run(*args):
    returncode = call(args)
    if returncode != 0:
        print >>sys.stderr, 'Command failed with error code %s.' % returncode
        sys.exit(1)

def mkdir_p(path):
    try:
        os.mkdir(path)
    except OSError:
        pass

curdate = time.strftime('%Y-%m-%d')
backupdest = os.path.join(MOUNTPOINT, curdate)

# Renice myself and all future children
run('/usr/bin/renice', '+19', str(os.getpid()))

# Mount the backup drive - I don't need this, because it mounts on its own
#print 'Mounting', MOUNTPOINT
#mkdir_p(MOUNTPOINT)
#run('mount', DEVICE, MOUNTPOINT)

print 'Backing up to %s with date %s' % (MOUNTPOINT, curdate)

# Create location
mkdir_p(backupdest)

# Find the previous backups.
prev_backups = glob.glob(os.path.join(MOUNTPOINT, '????-??-??'))
prev_backups.remove(backupdest)
prev_backups.sort()
if prev_backups:
    lastdest = prev_backups[-1]
    print 'Previous backup:', lastdest
else:
    print 'No previous backup found.'
    lastdest = None

# Backup this script
print
print 'Copying over backup script.'
run('/bin/cp', __file__, backupdest)

# Backup raid stuff.
print
print 'Rsyncing.'
# Note that we do --delete for when a backup is redone on the same day.
command = ['/usr/bin/rsync', '-av', '--delete']
if lastdest:
    command += ['--link-dest', lastdest]
for exclude in EXCLUDES:
    command += ['--exclude', exclude]
command +=  PATHS
command.append(backupdest)
if call(command) == 0:
    print
    print 'Rsync succeeded.'
else:
    print 'Rsync failed.  This could be because of the common error:'
    print '"some files vanished before they could be transferred"'

# Unmount the backup drive - we don't need this because we don't mount
#print 'Umounting'
#if call(('/bin/umount', MOUNTPOINT)) != 0:
#    print 'Could not unmount %s.' % MOUNTPOINT
