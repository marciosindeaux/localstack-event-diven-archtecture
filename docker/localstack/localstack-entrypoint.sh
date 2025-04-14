#!/bin/bash

export AWSLOCAL=opt/code/localstack
export PATH=$PATH:$AWSLOCAL:$AWSLOCAL/bin

ROOT_CONFIG_DIR=/root/localstack/config

echo $ROOT_CONFIG_DIR
# awslocal sqs create-queue --queue-name minha-fila

echo ">>>>>>>>>>>>>>>>>> [Starting queue configurations] <<<<<<<<<<<<<<<<<<<<<<<<<<"
cd $ROOT_CONFIG_DIR/sqs
. queues-config.sh
echo ">>>>>>>>>>>>>>>>>> [Queues are configurated] <<<<<<<<<<<<<<<<<<<<<<<<<<"

echo ">>>>>>>>>>>>>>>>>> [Starting topic configurations] <<<<<<<<<<<<<<<<<<<<<<<<<<"
# cd $ROOT_CONFIG_DIR/sns
# . topics-config.sh
echo ">>>>>>>>>>>>>>>>>> [Topcs are configurated] <<<<<<<<<<<<<<<<<<<<<<<<<<"