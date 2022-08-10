#!/bin/bash

#
# Remove all files before new release
rm -rf /var/www/html/*
retval=$?
echo "$retval"
if [ $retval -ne 0 ] && [ $retval -ne 1 ]; then
exit retval;
fi

#
# Remove all hidden files before new release
rm -rf /var/www/html/.*
retval=$?
echo "$retval"
if [ $retval -ne 0 ] && [ $retval -ne 1 ]; then
exit retval;
fi

#
# Remove cron - will stop any crons during the deployment
crontab -r > /dev/null 2>&1
retval=$?
echo "$retval"
if [ $retval -ne 0 ] && [ $retval -ne 1 ]; then
exit retval;
fi
