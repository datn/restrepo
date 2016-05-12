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

if [ "x$1" = "x" ]
then
        die "Need an argument." 1
fi

df | grep -q ^s3fs.*\ $1$
MOUNTED=$?
if [ $MOUNTED -eq 1 ]
then
        mount $1
        RESULT=$?
        if [ $RESULT -ne 0 ]
        then
                die "Mounting $1 on s3fs exited nonzero: $RESULT -- exiting." $RESULT
        fi
else
        echo "$1's already mounted."
fi

