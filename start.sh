#!/bin/sh

set -e

log_dir=/var/log/redis-cluster
lock_file=/data/cluster.lock

mkdir -p $log_dir

# Initialize configs
for p in 6379
do
  conf_path=/redis-$p.conf
  data_dir=/data/redis-$p

  mkdir -p $data_dir
  cp /redis.conf $conf_path
  echo "
port $p
dir $data_dir" >> $conf_path

  echo "
[program:redis-$p]
command=redis-server $conf_path
autorestart=unexpected
stdout_logfile=$log_dir/$p.log" >> /supervisord.conf
done

# Start Redis servers
supervisord
sleep 3



tail -f $log_dir/*.log
