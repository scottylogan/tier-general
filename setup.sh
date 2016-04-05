#! /bin/sh

if [ -f environment ]; then
  echo "environment file already exists; not overwriting" >&2
  exit 1
fi

exec >environment
now=`date +%FT%T%z`
echo '#' TIER environment generated at ${now}
echo MYSQL_ROOT_PASSWORD=`dd if=/dev/urandom bs=30 count=1 2>/dev/null| base64|tr '/+' '_-'`
echo MYSQL_GROUPER_USER=grouper
echo MYSQL_GROUPER_PASSWORD=`dd if=/dev/urandom bs=30 count=1 2>/dev/null| base64|tr '/+' '_-'`
