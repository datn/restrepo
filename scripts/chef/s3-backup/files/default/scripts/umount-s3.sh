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

umount $1
RESULT=$?
if [ $RESULT -ne 0 ]
then
       die "Unmounting $1 on s3fs exited nonzero: $RESULT -- exiting." $RESULT
fi

