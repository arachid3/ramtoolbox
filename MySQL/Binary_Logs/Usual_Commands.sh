# Decode ROW based binary logs
mysqlbinlog \
	--base64-output=DECODE-ROWS  --verbose \
	--start-datetime="2015-06-17 01:55:00" --stop-datetime="2015-06-17 02:10:00" \
	db20-bin-log.001289 > db20-bin-log.001289.1H55-2H10


# Parse binary log files using pt-query-digest
pt-query-digest --limit=100% --type=binlog mysql-bin.000005.dump


# Get some insights from the binary log
grep -i "^### UPDATE" db20-bin-log.001289.1H55-2H10 | sort | uniq -c | sort -n
