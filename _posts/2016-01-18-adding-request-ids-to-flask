---
layout: post
date: 2016-01-18
title: Adding Request IDs to Flask
---

In the financial world, we often work with software and vendors that do things in odd or outdated ways. Some things may be documented or not, some fields may be reused in certain situations, and some behavior is acknowledged as a bug but can't change due to backwards-compatibility.

At work, we've created a REST server that abstracts a lot of these problems to give us a stable platform to build our software on top of. It handles all of the inconsistencies in one place so that we aren't stuck reinventing the wheel (or shooting our own feet) on every project we come across. 

We build up larger programs using these small and stable building blocks. If something is likely to be used in multiple places, we'll add it to the REST server. This can mean that we'll have endpoints that call other endpoints.

Imagine you want to have a way of reporting a credit card stolen. The request chain may look something like this:

```
# Send card details
POST /cards/lost_and_stolen/

    # First, look up the card details
    GET /cards/1234567890123456/

    # Look up the owning account to ensure it's still open
    GET /accounts/123456/

    # Close the card
    DELETE /cards/1234567890123456/

    # Finally, order a new card for the member
    POST /accounts/123456/card/
```

When laid out like that, the five requests a relatively easy to follow. Unfortunately, we have 30-50 requests per second and are growing that number on a monthly basis. When something happens in the middle of that chain, it can be hard to debug exactly what went wrong. That's why we added request IDs.

# Request IDs
A request ID is a unique identifier for each request. We decided that we wanted to be able to search for both a unique action and an entire request chain, so we implemented the following model:

1. If a request comes in with no request ID, generate a unique one.
2. If a request comes in with a request ID, add a comma and add a unique one.

This allows the following request chain (which could have any number of requests in between them) go from this:

```
POST /cards/lost_and_stolen/
GET /cards/1234567890123456/
GET /accounts/123456/
DELETE /cards/1234567890123456/
POST /accounts/123456/card/
```

To this:

```
0dadb33f-ee15-470a-bfc8-5e35926793a5 POST /cards/lost_and_stolen/
0dadb33f-ee15-470a-bfc8-5e35926793a5,ac0eabbd-122f-491c-aacf-670d255eef3d GET /cards/1234567890123456/
0dadb33f-ee15-470a-bfc8-5e35926793a5,f2aab75e-719f-4a00-8d81-a1266cfb6a81 GET /accounts/123456/
0dadb33f-ee15-470a-bfc8-5e35926793a5,639832bf-111c-40ac-abed-bf93ae15c54d DELETE /cards/1234567890123456/
0dadb33f-ee15-470a-bfc8-5e35926793a5,68493175-8a39-421b-99e9-53e937fa5d12 POST /accounts/123456/card/
```

This also helps with scheduled jobs which may be scheduled days or weeks in the future. These request IDs are logged and read into [Logstash](logstash) where we can then view the lifecycle of any request that comes into our system. Applications that send requests are able to submit their own request IDs such that we can track requests that start in application A, go to our REST server, and respond back, and can track the entire interaction using [Kibana](kibana).

# Implementation

Our REST server is implemented in [Flask](flask). Here's how we implemented this. First, we set up all of the heavy lifting in `utils.py`. 

```
# utils.py
import uuid
import logging
import flask

# Generate a new request ID, optionally including an original request ID
def generate_request_id(original_id=''):
    new_id = uuid.uuid4()

    if original_id:
        new_id = "{},{}".format(original_id, new_id)

    return new_id

# Returns the current request ID or a new one if there is none
# In order of preference:
#   * If we've already created a request ID and stored it in the flask.g context local, use that
#   * If a client has passed in the X-Request-Id header, create a new ID with that prepended
#   * Otherwise, generate a request ID and store it in flask.g.request_id
def request_id():
    if getattr(flask.g, 'request_id', None):
        return flask.g.request_id

    headers = flask.request.headers
    original_request_id = headers.get("X-Request-Id")
    new_uuid = generate_request_id(original_request_id)
    flask.g.request_id = new_uuid

    return new_uuid

class RequestIdFilter(logging.Filter):
    # This is a logging filter that makes the request ID available for use in
    # the logging format. Note that we're checking if we're in a request
    # context, as we may want to log things before Flask is fully loaded.
    def filter(self, record):
        record.request_id = request_id() if flask.has_request_context() else ''
        return True
```

Next, we'll set up our logging format. 

```
# log.py
import logging.config

LOG_CONFIG = {
    'version': 1,
    'filters': {
        'request_id': {
            '()': 'utils.RequestIdFilter',
        },
    },
    'formatters': {
        'standard': {
            'format': '%(asctime)s - %(name)s.%(module)s.%(funcName)s:%(lineno)d - %(levelname)s - %(request_id)s - %(message)s',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'level': 'DEBUG',
            'filters': ['request_id'],
            'formatter': 'standard'
        }
    },
    'loggers': {
        '': {
            'handlers': ['console'],
            'level':'DEBUG',
        },
        'app': {
            'handlers': ['console'],
            'level':'DEBUG',
        },
    }
}

logging.config.dictConfig(LOG_CONFIG)
```

Next, we'll set up a small Flask app to show it in action. 
```
# server.py
import logging
import utils
import log
from flask import Flask

logger = logging.getLogger(__name__)
app = Flask(__name__)

@app.route("/")
def hello():
    logger.info("Sending our hello")
    return "Hello World!"

if __name__ == "__main__":
    app.run()
```

Finally, we can send some requests and see that the logging and request IDs are working. 

```
adam@puck:~/tmp$ source venv/bin/activate
(venv)adam@puck:~/tmp$ python server.py 
2016-01-18 02:40:19,258 - werkzeug._internal._log:87 - INFO -  -  * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
2016-01-18 02:40:42,543 - __main__.server.hello:11 - INFO - 266e188c-f8d8-48bd-a285-eabc4f0a598f - Sending our hello
2016-01-18 02:40:42,543 - werkzeug._internal._log:87 - INFO -  - 127.0.0.1 - - [18/Jan/2016 02:40:42] "GET / HTTP/1.1" 200 -
2016-01-18 02:42:51,959 - __main__.server.hello:11 - INFO - my_header,8a535551-7c1d-48fe-bc64-1d18431fc9ef - Sending our hello
2016-01-18 02:42:51,960 - werkzeug._internal._log:87 - INFO -  - 127.0.0.1 - - [18/Jan/2016 02:42:51] "GET / HTTP/1.1" 200 -
```

Here we see a request sent with no header running with a generated request ID and one passed in with "my_header" that has a new one appended to the end. 

(logstash): https://www.elastic.co/products/logstash
(kibana): https://www.elastic.co/products/kibana
(flask): http://flask.pocoo.org/
