#!/bin/sh
# Backup on S3 Amazon
BACKUP_DIR=/backup

# DATES
DATE=`date +%Y-%m-%d`
DAYWEEK=`date +%u`
MONTH=`date +%m`

# CLEAR DIR
#mkdir -p ${BACKUP_DIR}
rm -fr ${BACKUP_DIR}/*

# HOME
SITES=`ls -1 /home/`
cd ${BACKUP_DIR}
for SITE in ${SITES}; do
tar -zcvf ${BACKUP_DIR}/${SITE}-${DATE}.tar.gz /home/${SITE}/
done

# ALL DATA BASES
DB_LIST=`/usr/bin/mysql -Bse 'show databases'`
cd ${BACKUP_DIR}/db
for DB in ${DB_LIST}; do
if [ $DB != 'information_schema' ]
then
/usr/bin/mysqldump ${DB} > ${DB}.sql
tar -zcvf ${BACKUP_DIR}/db/${DB}-db-${DATE}.tar.gz ${DB}.sql
rm ${DB}.sql
fi
done

# ETC
tar -zcvpf ${BACKUP_DIR}/etc-${DATE}.tar.gz /etc

# Backup on weekdays
/usr/bin/s3cmd --acl-private --bucket-location=EU --guess-mime-type sync ${BACKUP_DIR}/ s3://mys3name/weekdays/${DAYWEEK}/
# Copy last backup in current month dir
/usr/bin/s3cmd --acl-private --bucket-location=EU --guess-mime-type sync s3://mys3name/weekdays/${DAYWEEK}/ s3://mys3name/months/${MONTH}/

