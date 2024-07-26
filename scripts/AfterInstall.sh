#!/bin/bash

echo Deployment Group Name: $DEPLOYMENT_GROUP_NAME
if [ "$DEPLOYMENT_GROUP_NAME" == "v2-knowledge-base-book-stack-PROD-internal" ]; then
  s3_bucket="verofy-2-production-private-env-files/verofy-2-knowledge-base-book-stack-internal"
elif [ "$DEPLOYMENT_GROUP_NAME" == "v2-knowledge-base-book-stack-PROD-customer" ]; then
  s3_bucket="verofy-2-production-private-env-files/verofy-2-knowledge-base-book-stack-customer"
elif [ "$DEPLOYMENT_GROUP_NAME" == "v2-knowledge-base-book-stack-PROD-partner" ]; then
  s3_bucket="verofy-2-production-private-env-files/verofy-2-knowledge-base-book-stack-partner"
elif [ "$DEPLOYMENT_GROUP_NAME" == "v2-knowledge-base-book-stack-STG" ]; then
  s3_bucket="verofy-2-staging-private-env-files/verofy-2-knowledge-base-book-stack"
fi

# Set permissions to storage and bootstrap cache
sudo chmod -R 0775 /var/www/html/storage
sudo chmod -R 0775 /var/www/html/bootstrap/cache
sudo chmod -R 0775 /var/www/html/public/uploads
sudo chmod -R 0775 /var/www/html/storage/framework/cache
sudo chmod -R 0775 /var/www/html/storage/framework/cache/data
sudo chown -R www-data:www-data /var/www/html

#
cd /var/www/html

#
# Run composer
sudo /usr/local/bin/composer install --no-ansi --no-dev --ignore-platform-reqs --no-interaction --no-progress --prefer-dist --no-scripts -d /var/www/html
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

#
# Build NPM
sudo npm install
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

sudo npm run build
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

#
# Copy env file from a S3
sudo aws --region eu-west-1 s3 cp "s3://$s3_bucket/.env" "/var/www/html/.env"
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

#
# Run artisan commands
php /var/www/html/artisan migrate --force
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

#
# Clear all
php /var/www/html/artisan cache:clear
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

php /var/www/html/artisan config:clear
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

php /var/www/html/artisan config:cache
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

php /var/www/html/artisan route:cache
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi

#
# Add Cron
(crontab -l 2>/dev/null; echo "* * * * * /usr/bin/php /var/www/html/artisan schedule:run >> /dev/null 2>&1") | crontab -
retval=$?
echo "$retval"
if [ $retval -ne 0 ]; then
exit retval;
fi
