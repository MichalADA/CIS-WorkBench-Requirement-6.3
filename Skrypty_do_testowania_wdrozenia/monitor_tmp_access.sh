#!/bin/bash

REPORT_DIR="/var/reports"
mkdir -p $REPORT_DIR
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/tmp_access_$DATE.log"

echo "=== Monitorowanie działań w katalogach tymczasowych (/tmp i /var/tmp) ===" > $REPORT_FILE
echo "" >> $REPORT_FILE

sudo ausearch -k tmp_access -ts today | aureport -f >> $REPORT_FILE
sudo ausearch -k var_tmp_access -ts today | aureport -f >> $REPORT_FILE

echo "Raport został zapisany do: $REPORT_FILE"
