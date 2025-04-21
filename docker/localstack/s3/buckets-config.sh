#!/bin/bash

STORAGE_FILES_CONFIG=$(pwd)/storages
cd $STORAGE_FILES_CONFIG

for storage in *.json
do
    echo ">>>>>>>>>>>>>>>>>> [Reading file: $storage] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    S3_NAME=$(ls $storage | awk -F. '{print $1}')

    echo ">>>>>>>>>>>>>>>>>> [Creating S3 $S3_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    awslocal s3api create-bucket --bucket $S3_NAME

    if [[ $? -eq 0 ]]
    then 
        echo ">>>>>>>>>>>>>>>>>> [$S3_NAME created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    else 
        echo ">>>>>>>>>>>>>>>>>> [$S3_NAME was not created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        return 1
    fi

    echo ">>>>>>>>>>>>>>>>>> [Setting ACL to S3 $S3_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    awslocal s3api put-bucket-acl --bucket $S3_NAME --acl public-read
    sed -i "s/{{defaultRegion}}/$AWS_DEFAULT_REGION/g" $(pwd)/$storage
    echo ">>>>>>>>>>>>>>>>>> [Setting notification configuration to $S3_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    awslocal s3api put-bucket-notification-configuration --bucket $S3_NAME --notification-configuration file://./$storage
    echo ">>>>>>>>>>>>>>>>>> [Notification configurated to $S3_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
done