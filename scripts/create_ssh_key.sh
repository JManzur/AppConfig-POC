#!/bin/bash
# Create a EC2 SSH Key Pair using AWS CLI
# Ref.: https://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html

#Variables:
KEY_NAME=AppConfig_POC
PROFILE=CTesting
REGION=us-east-1

#Create Key:
echo creating key $KEY_NAME on AWS Account $PROFILE $REGION
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem --region $REGION --profile $PROFILE
#Set Permissions:
chmod 400 $KEY_NAME.pem
#Move key to .shh
mv $KEY_NAME.pem ~/.ssh/$KEY_NAME.pem