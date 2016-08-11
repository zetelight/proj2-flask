#
# Second app: Flask project
#
# Gnu make and bash are required. 
#
# To run from source: 
#    bash ./configure
#    make run 
# 
#  'make configure' may also work, but with error
#   messages.

SOURCES = flask_syllabus.py pre.py

Makefile.local: 
	bash ./configure

include Makefile.local  ## Where customizations go 

##
##  Virtual environment
##     
env:
	$(PYVENV)  env
	(.  env/bin/activate; pip install -r requirements.txt)


##
## Preserve virtual environment
##
dist:
	pip freeze >requirements.txt

# 'make run' will run our program
# 
run:	$(SOURCES) env
	( . env/bin/activate; python3 flask_syllabus.py ) || true


# 'clean' and 'veryclean' are typically used before checking 
# things into git.  'clean' should leave the project ready to 
# run, while 'veryclean' may leave project in a state that 
# requires re-running installation and configuration steps
# 
clean:
	rm -f *.pyc
	rm -rf __pycache__

veryclean:
	make clean
	rm -f CONFIG.py
	rm -rf env
	rm -f Makefile.local



