#!/bin/bash
# Delete CloudWatch Log Group using AWS CLI
# Ref.: https://docs.aws.amazon.com/cli/latest/reference/logs/delete-log-group.html

#Variables:
GROUP_NAME=VPCFlowLogs
PROFILE=CTesting
REGION=us-east-1

#Delete log group:
aws logs delete-log-group --log-group-name $GROUP_NAME --region $REGION --profile $PROFILE