from botocore.exceptions import ClientError
import boto3
import logging
import json

# Instantiate AppConfig Client
client = boto3.client('appconfig')

# Instantiate logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f'event: {event}')
    api_json_list = [
        {
            'Name': 'Shawshank Redemption'
        },
        {
            'Name': 'The Matrix'
        },
        {
            'Name': 'Forrest Gump'
        },
        {
            'Name': 'The Lord of the Rings'
        },
        {
            'Name': 'Harry Potter'
        },
        {
            'Name': 'Pulp Fiction'
        },
        {
            'Name': 'Star Wars'
        },
        {
            'Name': 'Joker'
        },
        {
            'Name': 'The Godfather'
        },
        {
            'Name': 'Awakenings'
        }
    ]
    try:
        response = client.get_configuration(
            Application='POC-Application',
            Environment='POC-DEV',
            Configuration='UpdateAttribute',
            ClientId='POC-Lambda' #User defined value (could be any string).
            )
        resp_json = json.loads(response['Content'].read())
        logging.info(resp_json)
        EnableLimit = resp_json['EnableLimit']

        # If limiting is enabled, return limited json list:
        if EnableLimit == True:
            ResultLimit = resp_json["ResultLimit"]
            if ResultLimit > (len(api_json_list)):
                error_message = "Index out of range, max allow: {}".format((len(api_json_list)))
                logging.error(error_message)
                return {
                        'statusCode': 400,
                        'response_from': 'Lambda',
                        'body': error_message
                        }
            else:
                try:
                    new_json = slice(ResultLimit)
                    return {
                        'statusCode': 200,
                        'response_from': 'Lambda',
                        'body': api_json_list[new_json]
                        }
                except Exception as error:
                    logging.error(error)

        # If limiting not enabled, return full json list:
        else:
            return {
                'statusCode': 200,
                'response_from': 'Lambda',
                'body': api_json_list
                }

    # If Boto3 Client Error:
    except ClientError as error:
        logging.error(error)
        return {
            'statusCode': 500,
            'response_from': 'Lambda',
            'body': error,
			'moreInfo': {
                'Lambda Request ID': '{}'.format(context.aws_request_id),
                'CloudWatch log stream name': '{}'.format(context.log_stream_name),
                'CloudWatch log group name': '{}'.format(context.log_group_name)
			}
        }