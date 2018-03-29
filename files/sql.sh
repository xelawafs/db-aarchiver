#!/bin/bash

# Check database for the number of prefixed tables that need to be archived and store the count in ARCHIVE_CNT
ARCHIVE_CNT=$(mysql -u $1 -p$2 -D $3 -Bse "SELECT COUNT(*)  FROM information_schema.tables  WHERE table_schema = '$3' AND table_name like '$4%'")

# If ARCHIVE_CNT is greater than 0, it means there are new archived tables since the last backup. If so, they are processed and dumped in a .sql file
if [ $ARCHIVE_CNT -gt 0 ]
then
  mysqldump -u $1 -p$2 $3 $(mysql -u $1 -p$2 $3 -Bse "show tables like '$4%'") > /tmp/$3-$4-$5.sql
fi

# Determine notifications by failing on sql error, returning 0 number of tables to be archived or returning number of tables to be archived
if [ $ARCHIVE_CNT -eq 0 ] || [ $ARCHIVE_CNT -gt 0 ]
then
  echo $ARCHIVE_CNT
else
  ARCHIVE_CNT=$(mysql -u $1 -p$2 -D $3 -Bse "SELECT COUNT(*)  FROM information_schema.tables  WHERE table_schema = '$3' AND table_name like '$4%'")
fi
