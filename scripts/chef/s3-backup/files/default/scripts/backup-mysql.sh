#!/bin/bash
DATE=`date +%G%V`
HOST=`hostname`
/usr/local/bin/innobackupex-runner.sh
chown -R backup /backups/mysql/
