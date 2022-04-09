from botocore.exceptions import ClientError
from appconfig_helper import AppConfigHelper
from fastapi import FastAPI, status
import logging
import os

# Set AWS Region
os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'

# Instantiate logger
logger = logging.basicConfig(
    filename='/opt/sitcom_api/sitcom_api.log',
    format='[%(asctime)s] %(levelname)s %(name)s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S'
    )

# Fetch configuration from AWS AppConfig
appconfig = AppConfigHelper(
    "POC-Application", #Application
    "POC-DEV", #Environment
    "UpdateAttribute", #Configuration Profile
    45  # Minimum interval between update checks (in seconds)
)

app = FastAPI()

# Root API Page:
@app.get("/")
async def root():
    api_json_list = [
        {
            'Name': 'The IT Crowd'
        },
        {
            'Name': 'Seinfeld'
        },
        {
            'Name': 'The Office (U.S)'
        },
        {
            'Name': 'Silicon Valley'
        },
        {
            'Name': 'Brooklyn Nine-Nine'
        },
        {
            'Name': 'Friends'
        },
        {
            'Name': 'The Big Bang Theory'
        },
        {
            'Name': 'The Simpsons'
        },
        {
            'Name': 'Frasier'
        },
        {
            'Name': 'Community'
        }
    ]
    try:
        # Log when new configuration is received:
        if appconfig.update_config():
            logging.info("New configuration Received")
        
        # If limiting is enabled, return limited json list:
        if appconfig.config.get("EnableLimit", True):
            limit = appconfig.config["ResultLimit"]
            if limit > (len(api_json_list)):
                error_message = "Index out of range, max allow: {}".format((len(api_json_list)))
                logging.error(error_message)
                return {
                        'statusCode': 400,
                        'response_from': 'EC2',
                        'body': error_message
                        }
            else:
                try:
                    new_json = slice(limit)
                    return {
                        'statusCode': 200,
                        'response_from': 'EC2',
                        'body': api_json_list[new_json]
                        }
                except Exception as error:
                    logging.error(error)
        
        # If limiting not enabled, return full json list:
        else:
            return {
                'statusCode': 200,
                'response_from': 'EC2',
                'body': api_json_list
                }

    #If Boto3 Client Error: Keep the server running, log the error and return the error message.
    except ClientError as error:
        logging.error(error)
        return {
            'statusCode': 500,
            'response_from': 'EC2',
            'body': error
            }

# Healthcheck - Status Page
@app.get('/status', status_code=status.HTTP_200_OK)
async def perform_healthcheck():
        return {
            'statusCode': 200,
            'response_from': 'EC2',
            'healthcheck': 'WSGI OK!'
        }