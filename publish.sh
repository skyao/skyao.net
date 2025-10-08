#!/bin/bash
workPath=$(dirname $0)
cd $workPath
workPath=$(pwd)
echo "work path is $workPath"

rm -rf public
env HUGO_ENV="production" hugo --baseURL="https://skyao.net"
if [ $? -ne 0 ]; then
    echo "Fail to build html content by hugo, exit"
    exit 1
fi
echo "Success to build skyao.net site"

cd /var/www/skyao
ls /var/www/skyao | grep -v learning | xargs rm -rf
if [ $? -ne 0 ]; then
    echo "Fail to remove exist html content, exit"
    exit 1
fi

cd $workPath
cp -r public/* /var/www/skyao
if [ $? -ne 0 ]; then
    echo "Fail to copy html content, exit"
    exit 1
fi

echo "Success to publish skyao.net site"
