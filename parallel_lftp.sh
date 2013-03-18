#!/bin/sh
#
# parallel_lftp.sh
#
# original script coded by Takashi Unuma, Kyoto Univ.
#
# Last modified: 2013/03/18
#
# ----------
# USAGE: 
#  $ parallel_lftp.sh --url=URL
#  $ parallel_lftp.sh --userid=USERID --passwd=PASSWD
#  $ parallel_lftp.sh --parallel=N --use-pget-n=N
#  $ parallel_lftp.sh --dir="path-to-dir"
#
LANG=C
LC_ALL=C
set -e

opts=""
# extract opts
for arg in $*; do
    case ${arg} in
	--*=*)
	key=${arg%%=*}; key=${key##--}
	value=${arg##--*=}
	eval ${key}=${value}
	opts="${opts} ${key}"
	;;
    esac
done

# check args
if test ${#url} -lt 1 ; then
    echo "please specify the URL as follows: "
    echo " ex) $ parallel_lftp.sh --url=[URL] "
    exit 1
elif test ${#ddir} -lt 1 ; then
    echo "please specify the DIR as follows: "
    echo " ex) $ parallel_lftp.sh --ddir=[PATH-TO-DIR] "
    exit 1
fi

ddir=${ddir}
url=${url}
npget=${npget:-1}
npara=${npara:-1}
userid=${userid}
passwd=${userid}

echo "--- parameters below ---"
echo " url:   ${url}"
echo " dir:   ${ddir}"
echo " npget: ${npget}"
echo " npara: ${npara}"
echo ""

lftp -u ${userid},${passwd} ${url} -e "mirror -c --parallel=${npara} --use-pget-n=${npget} ${ddir}/" << EOF
quit
EOF

