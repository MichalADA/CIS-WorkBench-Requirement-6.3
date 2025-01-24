#!/bin/bash

REPORT_DIR="/var/reports"
mkdir -p $REPORT_DIR
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/command_exec_$DATE.log"

echo "=== Monitorowanie uruchamianych poleceń ===" > $REPORT_FILE
echo "" >> $REPORT_FILE

sudo ausearch -k command_exec -ts today | aureport -f >> $REPORT_FILE

echo "Raport został zapisany do: $REPORT_FILE"
