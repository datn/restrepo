#!/bin/bash
#
die() {
    [[ $1 ]] || {
        printf >&2 -- 'Usage:\n\tdie <message> [return code]\n'
        [[ $- == *i* ]] && return 1 || exit 1
    }

    printf >&2 -- '%s' "$1"
    echo ""
    exit ${2:-1}
}

DEST=/backups/data/svnserver-hostname/
DATE=`date +%Y%m%d%H%M`
/usr/local/bin/mount-s3.sh /backups 

if [ -d $DEST -a -w $DEST ]
then
	LIST=`find /var/lib/svn -type f -mtime -90 | cut -d\/ -f5 | uniq `
	for I in $LIST
	do
		svnadmin dump /var/lib/svn/$I | gzip > $DEST/$I-$DATE.svndump.gz
	done
else
	die "ERROR: Can't write to destination dir $DEST." $?
fi

echo "Sleeping 10 seconds to let s3fs calm down."
sleep 10
/usr/local/bin/umount-s3.sh /backups 
