#!/bin/bash

is_fifo_queue() {
    if [[ "$1" == *'fifo'* ]] 
    then 
        echo ">>>>>>>>>>>>>>>>>> [$1 Its a FIFO queue] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        return 1
    else 
        echo ">>>>>>>>>>>>>>>>>> [$1 Its not a FIFO queue] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        return 0
    fi
}

create_dlq() {
    QUEUE_FILE_NAME=$1
    QUEUE_NAME=$(ls $QUEUE | awk -F. '{print $1}')-dlq

    is_fifo_queue $QUEUE_FILE_NAME
    if [[ $? -eq 1 ]]
    then
        QUEUE_NAME=$QUEUE_NAME.fifo
    fi

    echo ">>>>>>>>>>>>>>>>>> [Creating queue $QUEUE_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    awslocal sqs create-queue --queue-name $QUEUE_NAME --attributes file://./$QUEUE_FILE_NAME
    if [[ $? -eq 0 ]]
    then 
        echo ">>>>>>>>>>>>>>>>>> [$QUEUE_NAME created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo ">>>>>>>>>>>>>>>>>> [Getting ARN from $QUEUE_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        DLQ_SQS_ARN=$( awslocal sqs get-queue-attributes --queue-url=http://127.0.0.1:4576/000000000000/$QUEUE_NAME --attribute-name QueueArn  |
        sed 's/"QueueArn"/\n"QueueArn"/g' | grep '"QueueArn"' | awk -F '"QueueArn":' '{print $2}' | tr -d '"' | xargs)

        echo ">>>>>>>>>>>>>>>>>> [Replacing ARN from $QUEUE_NAME in original queue File] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        sed -i "s/{{dlqArn}}/$DLQ_SQS_ARN/g" $(pwd)/$QUEUE_FILE_NAME

        cat $QUEUE_FILE_NAME
        echo ">>>>>>>>>>>>>>>>>> [Redrive Policy Created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    else 
        echo ">>>>>>>>>>>>>>>>>> [$QUEUE_NAME was not created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        return 1
    fi
}

create_queue() {
    QUEUE_FILE_NAME=$1
    QUEUE_NAME=$(ls $QUEUE | awk -F. '{print $1}')
    
    
    is_fifo_queue $QUEUE_FILE_NAME
    if [[ $? -eq 1 ]]
    then
        QUEUE_NAME=$QUEUE_NAME.fifo
    fi

    echo ">>>>>>>>>>>>>>>>>> [Creating queue $QUEUE_NAME] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    awslocal sqs create-queue --queue-name $QUEUE_NAME --attributes file://./$QUEUE_FILE_NAME

    if [[ $? -eq 0 ]]
    then 
        echo ">>>>>>>>>>>>>>>>>> [$QUEUE_NAME created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    else 
        echo ">>>>>>>>>>>>>>>>>> [$QUEUE_NAME was not created] <<<<<<<<<<<<<<<<<<<<<<<<<<"
        return 1
    fi
}


QUEUE_FILES_CONFIG=$(pwd)/queues
cd $QUEUE_FILES_CONFIG

for QUEUE in *.json;
do
    echo ">>>>>>>>>>>>>>>>>> [Reading file: $QUEUE] <<<<<<<<<<<<<<<<<<<<<<<<<<"
    create_dlq $QUEUE
    create_queue $QUEUE
done

    
    