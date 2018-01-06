#!/bin/sh
BN=`basename $0`
TMPLOG="bldlog-1.txt"

if [ -z "$TIDY_ROOT" ]; then
    echo "$BN: TIDY_ROOT NOT set in environment, using default '/usr'."
    TMPROOT="/usr"
else
    TMPROOT="$TIDY_ROOT"
fi    

if [ -f "$TMPLOG" ]; then
    rm -fv "$TMPLOG"
fi

echo "$BN: Build of HTML::Tidy... out to '$TMPLOG'"
echo "$BN: Build of HTML::Tidy... out to '$TMPLOG'" > $TMPLOG
if [ -f "Makefile" ]; then
    rm -fv Makefile
fi

echo "$BN: Setting the environment... export TIDY_ROOT=$TMPROOT"
echo "$BN: Setting the environment... export TIDY_ROOT=$TMPROOT" >> $TMPLOG
export TIDY_ROOT=$TMPROOT

echo "$BN: Doing: 'perl Makefile.PL'"
echo "$BN: Doing: 'perl Makefile.PL'" >> $TMPLOG
perl Makefile.PL >> $TMPLOG 2>&1
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

