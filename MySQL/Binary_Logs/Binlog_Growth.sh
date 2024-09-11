# Change the search pattern name
#
find . -name "mysql-bin.*" -exec ls -lt --time-style=+%F {} \; | awk 'BEGIN{FS=" "; print "Date\t\t Files\t Total \t\t PerHour"} NR!=1 {a[$6]++;sum[$6]=sum[$6]+$5}END{for (i in a) printf("%s %10.0f %10.2f MB %10.2f MB\n", i, a[i], sum[i]/1048576, sum[i]/24/1048576)} '


# Binary log growth estimate automated script
#
for srvr in server1 server2; do
  # get binlog dir
  BINLOGDIR=$(dirname $(db_connect $srvr --silent -N --raw -e "select @@log_bin_basename"));

  # get binlog name
  BINLOGNAME=$(basename $(db_connect $srvr --silent -N --raw -e "select @@log_bin_basename"));

  echo $srvr; echo "-------------------";
  echo "Binlog Dir: $BINLOGDIR - Binlog Basename: $BINLOGNAME";
  echo "-------------------";

  # ship the script to respective server
  scp -q binlog_size.sh $srvr:/tmp/;
  
  # execute the script
  echo "$srvr: sh /tmp/binlog_size.sh $BINLOGDIR/ $BINLOGNAME";
  ssh -q -o "StrictHostKeyChecking no" $srvr "sh /tmp/binlog_size.sh $BINLOGDIR/ $BINLOGNAME";
  echo "-------------------"; echo;
done
