#!/bin/bash

export AWSLOCAL=opt/code/localstack
export PATH=$PATH:$AWSLOCAL:$AWSLOCAL/bin

ROOT_CONFIG_DIR=/root/localstack/config

echo $ROOT_CONFIG_DIR

echo ">>>>>>>>>>>>>>>>>> [Starting Stack Configuration] <<<<<<<<<<<<<<<<<<<<<<<<<<"
cd $ROOT_CONFIG_DIR/cloud-formation-stack
awslocal cloudformation create-stack --stack-name queue-stack --template-body file://cloudwatch-stack.yaml
echo ">>>>>>>>>>>>>>>>>> [Ending Stack Configuration] <<<<<<<<<<<<<<<<<<<<<<<<<<"