#!/bin/bash

# dump a list of archived tables to a file
mysql -B $3 -u$1 -p$2 --disable-column-names  -e "SELECT CONCAT(TABLE_SCHEMA, '.', TABLE_NAME) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE '$4%' AND TABLE_SCHEMA = '$3';" > /tmp/table_to_delete.sql

# open file with list of archived tables and loop through it deleting all archived tables which should be backed up on the S3 bucket by now
while read db_line; do
  mysql -u$1 -p$2 -e "DROP TABLE $db_line"
done < /tmp/table_to_delete.sql
