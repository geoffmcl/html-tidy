#!/bin/sh
BN=`basename $0`
TMPLOG="bldlog-t.txt"

if [ -f "$TMPLOG" ]; then
    rm -fv "$TMPLOG"
fi

echo "$BN: Testing HTML::Tidy... out to '$TMPLOG'"
echo "$BN: Testing of HTML::Tidy... out to '$TMPLOG'" > $TMPLOG$

echo "$BN: Doing 'make test'"
echo "$BN: Doing 'make test'" >> $TMPLOG
make test >> $TMPLOG 2>&1
if [ ! "$?" = "0" ]; then
    echo "$BN: Operation FAILED! See $TMPLOG..."
    exit 1
fi

echo "$BN: Appears operation suceeded... time for 'make install' if desired..."

# eof



