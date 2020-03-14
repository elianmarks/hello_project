#!/bin/bash

# variables
log_path="/var/log/nginx/access.log"
report="/var/log/report_result.log"
email="elian.markes@gmail.com"
col1="Requests"
col2="Path"
col3="Code"

# clean report and add coluns
printf "%10s | %25s | %10s\n" $col1 $col2 $col3 > $report

# for in codes
for code in 200 404 499
do
    awk -F' ' -v awk_code=$code '$9 == awk_code { request_count[$7]++ } END { for (i in request_count) { printf "%10s | %25s | %10s\n", request_count[i], i, awk_code } }' $log_path >> $report
done

# send email
echo "Report access log" | mailx -a $report -s "Report Nginx log" $email