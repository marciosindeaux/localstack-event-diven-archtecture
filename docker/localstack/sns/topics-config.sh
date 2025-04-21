#!/bin/bash

TOPICS_CONFIG_DIR=$(pwd)/topics
SUBSCRIPTIONS_CONFIG_DIR=$(pwd)/subscriptions

cd $TOPICS_CONFIG_DIR

for topic in *.json
do 
    echo "Lendo arquivo $topic",
    topic_name=$(ls $topic | awk -F. '{print $1}')

    awslocal sns create-topic --name $topic_name
    
done
