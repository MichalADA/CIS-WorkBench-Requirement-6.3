#!/bin/bash

REPORT_DIR="/var/reports"
mkdir -p $REPORT_DIR
DATE=$(date +"%Y-%m-%d")

grep "passwd_changes" /var/log/audit/audit.log > $REPORT_DIR/passwd_changes_$DATE.log
grep "sudoers_changes" /var/log/audit/audit.log > $REPORT_DIR/sudoers_changes_$DATE.log
grep "sudo_exec" /var/log/audit/audit.log > $REPORT_DIR/sudo_exec_$DATE.log
grep "logins" /var/log/audit/audit.log > $REPORT_DIR/logins_$DATE.log

echo "Raporty zostały zapisane w $REPORT_DIR"