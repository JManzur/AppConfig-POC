from fastapi import FastAPI, status

app = FastAPI()

@app.get("/")
async def root():
	api_json_list = [
        {
            'Name': 'Stairway to Heaven - Led Zeppelin'
        },
        {
            'Name': 'Bohemian Rhapsody - Queen'
        },
        {
            'Name': 'Hey Jude - Beatles'
        },
        {
            'Name': 'All Along the Watchtower -  Jimi Hendrix'
        },
        {
            'Name': 'Satisfaction - Rolling Stones'
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
	
	return {
		'statusCode': 200,
		'response_from': 'ECS',
		'body': api_json_list
	}

@app.get('/status', status_code=status.HTTP_200_OK)
async def perform_healthcheck():
        return {
            'statusCode': 200,
            'response_from': 'ECS',
            'healthcheck': 'WSGI OK!'
        }