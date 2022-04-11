#!/bin/bash
# Used by: ecs-task-definition.tf
# This script takes 4 input variables
# ./get_image_uri.sh {AWSRegion} {AWSProfile} {ECR_URL} {ECR_NAME}

# Set Variables
set -e

REGION="$1"
PROFILE="$2"
ECR_URL="$3"
ECR_NAME="$4"

# Get URI of the latest pushed image.
IMAGE_URI=$(aws ecr describe-images --output json --repository-name $ECR_NAME --region $REGION --profile $PROFILE --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' | jq . --raw-output)

# Echo the result
echo '{ "URI": "'"$ECR_URL:$IMAGE_URI"'" }'