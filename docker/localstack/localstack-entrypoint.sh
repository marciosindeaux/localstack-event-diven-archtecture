#!/bin/bash

export AWSLOCAL=opt/code/localstack
export PATH=$PATH:$AWSLOCAL:$AWSLOCAL/bin

ROOT_CONFIG_DIR=/root/localstack/config

echo $ROOT_CONFIG_DIR


cd $ROOT_CONFIG_DIR/cloud-formation-stack
for stack in *.yaml;
do
    stack_name=$(ls $stack | awk -F. '{print $1}')
    echo ">>>>>>>>>>>>>>>>>> [Starting Stack Configuration for $stack_name ] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    awslocal cloudformation create-stack --stack-name $stack_name --template-body file://$stack
    echo ">>>>>>>>>>>>>>>>>> [Ending Stack Configuration for $stack_name ] <<<<<<<<<<<<<<<<<<<<<<<<<<"
done
