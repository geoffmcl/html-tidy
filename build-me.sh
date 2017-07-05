#!/bin/sh
BN=`basename $0`
TMPLOG="bldlog-1.txt"

if [ -f "$TMPLOG" ]; then
    rm -fv "$TMPLOG"
fi

echo "$BN: Build of HTML::Tidy... out to '$TMPLOG'"
echo "$BN: Build of HTML::Tidy... out to '$TMPLOG'" > $TMPLOG
if [ -f "Makefile" ]; then
    rm -fv Makefile
fi
echo "$BN: Doing: 'perl -f Makefile.PL'"
echo "$BN: Doing: 'perl -f Makefile.PL'" >> $TMPLOG
perl -f Makefile.PL >> $TMPLOG 2>&1
if [ ! "$?" = "0" ]; then
    echo "$BN: Operation FAILED! See $TMPLOG..."
    exit 1
fi
if [ ! -f "Makefile" ]; then
    echo "$BN: Failed to create 'Makefile'!"
    exit 1
fi

echo "$BN: Doing 'make'"
echo "$BN: Doing 'make'" >> $TMPLOG
make >> $TMPLOG 2>&1
if [ ! "$?" = "0" ]; then
    echo "$BN: Operation FAILED! See $TMPLOG..."
    exit 1
fi

echo "$BN: Doing 'make test'"
echo "$BN: Doing 'make test'" >> $TMPLOG
make test >> $TMPLOG 2>&1
if [ ! "$?" = "0" ]; then
    echo "$BN: Operation FAILED! See $TMPLOG..."
    exit 1
fi

echo "$BN: Appears operation suceeded... time for 'make install' if desired..."

# eof

