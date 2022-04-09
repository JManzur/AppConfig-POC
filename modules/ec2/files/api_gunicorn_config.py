# API Configuration
accesslog = '/opt/sitcom_api/sitcom_api.log'
loglevel = 'debug'
bind = '0.0.0.0:8080'
daemon = True
workers = 4
worker_class = 'uvicorn.workers.UvicornWorker'
threads = 2