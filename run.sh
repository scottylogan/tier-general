#! /bin/sh

set -e -x

TIER=`dirname $0`
[ -z ${TIER} ] || [ ${TIER} == '.' ] && TIER=${PWD}
echo $TIER
echo $PWD
TIER_DATA=${TIER}/data
TIER_DUMP=${TIER}/dump
MYSQL_NAME=tierdb

${TIER}/setup.sh || true
. environment
# mysql

mkdir -p ${TIER_DATA}/${MYSQL_NAME}
mkdir -p ${TIER_DUMP}/${MYSQL_NAME}

if [ ! -f ${TIER_DUMP}/${MYQL_NAME}/grouper.sql ]; then
  cat >${TIER_DUMP}/${MYSQL_NAME}/grouper.sql <<GROUPER_SQL
CREATE DATABASE IF NOT EXISTS \`grouper\`;
CREATE USER IF NOT EXISTS '${MYSQL_GROUPER_USER}'@'%' IDENTIFIED BY '${MYSQL_GROUPER_PASSWORD}';
GRANT ALL ON \`grouper\`.* TO '${MYSQL_GROUPER_USER}'@'%';
GROUPER_SQL
fi


docker run --rm \
  -h ${MYSQL_NAME} \
  --name ${MYSQL_NAME} \
  --env-file environment \
  -p 3306:3306 \
  -v ${TIER}/scripts/mysql-fix.sh:/mysql-fix.sh \
  -v ${TIER_DATA}/${MYSQL_NAME}:/var/lib/mysql \
  -v ${TIER_DUMP}/${MYSQL_NAME}:/docker-entrypoint-initdb.d \
  tier/mysql \
  /mysql-fix.sh >${MYSQL_NAME}.out 2>${MYSQL_NAME}.err &

#sleep 10

#docker run -it --rm \
#  -h test \
#  --name test \
#  --env-file environment \
#  --link ${MYSQL_NAME}:${MYSQL_NAME} \
#  tier/base:latest /bin/bash
