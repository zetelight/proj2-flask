"""
Very simple Flask web site, with one page
displaying a course schedule.

"""

import flask

import json
import logging

# Date handling 
import arrow # Replacement for datetime, based on moment.js
import datetime # But we still need time
from dateutil import tz  # For interpreting local times

# On shared machines we'll pick a random port
import random

# Our own module
import pre  # Preprocess schedule file


###
# Globals
###
app = flask.Flask(__name__)
schedule = "static/schedule.txt"  # This should be configurable

###
# Pages
###

@app.route("/")
@app.route("/schedule")
def index():
  app.logger.debug("Main page entry")
  if 'schedule' not in flask.session:
      app.logger.debug("Processing raw schedule file")
      raw = open('static/schedule.txt')
      flask.session['schedule'] = pre.process(raw)

  return flask.render_template('syllabus.html')


#################
#
# Functions used within the templates
#
#################

@app.template_filter( 'fmtdate' )
def format_arrow_date( date ):
    try: 
        normal = arrow.get( date )
        return normal.format("ddd MM/DD/YYYY")
    except:
        return "(bad date)"


#############


if __name__ == "__main__":
    import uuid
    app.secret_key = str(uuid.uuid4())
    # app.debug=True
    portnum = random.randint(5000,8000)
    app.config['SERVER_NAME']="ix.cs.uoregon.edu:{}".format(portnum)
    app.logger.setLevel(logging.DEBUG)
    app.logger.debug("Listening on port {}".format(portnum))
    app.run()

    
