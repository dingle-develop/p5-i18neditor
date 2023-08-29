#!/bin/bash

set -e
set -x

__DIR__=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

cd $__DIR__

if [ -z "$DINGLE_DEV_START" ] ; then
    if ! [ -f ENV.sh ] ; then
        cp ENV.sh.sample ENV.sh
        echo "Next please check the ENV.sh script. (Press return)"
        read x
        $EDITOR ENV.sh
    fi
    source ENV.sh
fi

if ! [ -d "$DINGLE_BASE_PATH" ] ; then
    echo "Can not find DINGLE_BASE_PATH '$DINGLE_BASE_PATH'."
    exit 1
fi

DINGLE="$DINGLE_BASE_PATH/bin/dingle"
if ! [ -e "$DINGLE" ] ; then
    echo "Can not find helper script dingle"
    exit 1
fi

requirements="$__DIR__/requirements.txt"

if [ -f "$requirements" ] ; then
    ( cd $DINGLE_BASE_PATH
      cpanm -L vendor --self-contained <$requirements
    )
fi

$DINGLE basedir
$DINGLE sitelib
