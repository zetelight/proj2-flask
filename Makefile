#
# Second app: Flask project Creates a date-sensitive course schedule
# (syllabus) that highlights the current week
# 

SRC = syllabus
SOURCES = $(SRC)/flask_syllabus.py $(SRC)/pre.py $(SRC)/credentials.ini


$(SRC)/credentials.ini:
	echo "You must create credentials.ini and save it in $(SRC)"

##
##  Virtual environment
##     
env:
	python3 -m venv  env
	(source env/bin/activate; pip install -r requirements.txt)


##
## Preserve virtual environment
##
dist:
	pip freeze >requirements.txt

# 'make run' runs Flask's built-in test server, 
#  which may be configured with built-in debugging
# 
run:	$(SOURCES) env
	(source env/bin/activate; cd syllabus; \
	python3 flask_syllabus.py ) || true

# 'make service' runs as a background job under the gunicorn 
#  WSGI server.  Could be configured to with nginx reverse proxy. 
#
# 
service:	$(SOURCES) env
	echo "Launching green unicorn in background"
	( . env/bin/activate; cd syllabus; \
          gunicorn --bind="0.0.0.0:8000" flask_syllabus:app &) 


# 'clean' and 'veryclean' are typically used before checking 
# things into git.  'clean' should leave the project ready to 
# run, while 'veryclean' may leave project in a state that 
# requires re-running installation and configuration steps
# 
clean:
	rm -f *.pyc */*.pyc
	rm -rf __pycache__

veryclean:
	make clean
	rm -rf env



