#!/usr/bin/env bash
# This script takes a snapshot of each EC2 volume that is tagged with Backup=1
# TODO: Add error handling and loop breaks

# Verify AWS CLI Credentials are setup
# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
if ! grep -q aws_access_key_id ~/.aws/config; then
  if ! grep -q aws_access_key_id ~/.aws/credentials; then
    echo "AWS config not found or CLI not installed. Please run \"aws configure\"."
    exit 1
  fi
fi

echo " "
echo "========================================================="
echo "Running some checks to confirm correct resource creation"
echo "========================================================="
echo " "

BUCKET="$(awk '{$1=$1};1' <<< $(aws s3api --no-paginate list-buckets --query "Buckets[].Name" | grep $(terraform output bucket_id)| tr ',' ' '))"
TOPIC="$(awk '{$1=$1};1' <<< $(aws sns --no-paginate list-topics |grep "$SNS_TOPIC_ARN" |awk '{ print $2 }'))"
SNS_TOPIC_ARN="$(sed -e 's/^"//' -e 's/"$//' <<< $(terraform output sns_topic_arn))"
EMAIL="$(awk '{$1=$1};1' <<< $(aws sns --no-paginate list-subscriptions-by-topic --topic-arn $SNS_TOPIC_ARN |grep "Endpoint" |awk '{ print $2 }' | tr ',' ' '))"
EMAIL_OUTPUT="$(awk '{$1=$1};1' <<<$(terraform output email_id))"


echo " "
echo "checking to see if topic exists"
echo " "
if [ -n "$TOPIC" ]
then
 echo "topic exists $SNS_TOPIC_ARN does not exist"  exit 1 
else
 echo "topic: $TOPIC exists"
fi

echo " "
echo "checking to see if bucket exists"
echo " "
if [ -n "$BUCKET" ] 
then
 echo "bucket $BUCKET exist"
else
 echo "bucket does not exist" exit 1 
fi

echo " "
echo "checking to see if the email is set"
echo " "
if [[ "$EMAIL" == "$EMAIL_OUTPUT" ]]
then
  echo "email is set to $EMAIL"
else
 echo "email doesn't appear to be set" exit 1
fi
