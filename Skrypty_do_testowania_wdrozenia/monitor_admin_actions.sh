#!/bin/bash

REPORT_DIR="/var/reports"
mkdir -p $REPORT_DIR
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/admin_actions_$DATE.log"

echo "=== Monitorowanie działań administracyjnych ===" > $REPORT_FILE
echo "" >> $REPORT_FILE

sudo ausearch -k sudo_exec -ts today | aureport -f >> $REPORT_FILE
sudo ausearch -k sudoers_changes -ts today | aureport -f >> $REPORT_FILE

echo "Raport został zapisany do: $REPORT_FILE"
