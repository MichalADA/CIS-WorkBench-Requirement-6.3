#!/bin/bash

REPORT_DIR="/var/reports"
mkdir -p $REPORT_DIR
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/user_permissions_$DATE.log"

echo "=== Monitorowanie zmian w plikach systemowych odpowiedzialnych za użytkowników i grupy ===" > $REPORT_FILE
echo "" >> $REPORT_FILE

sudo ausearch -k passwd_changes -ts today | aureport -f >> $REPORT_FILE
sudo ausearch -k shadow_changes -ts today | aureport -f >> $REPORT_FILE
sudo ausearch -k group_changes -ts today | aureport -f >> $REPORT_FILE
sudo ausearch -k gshadow_changes -ts today | aureport -f >> $REPORT_FILE

echo "Raport został zapisany do: $REPORT_FILE"
