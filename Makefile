#
# Second app: Flask project
#
# You must execute ./configure before this Makefile will work 
# 

SOURCES = flask_syllabus.py pre.py

Makefile.local: 
	sh ./configure

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
	( . env/bin/activate; python3 flask_syllabus.py || true)


# 'make configure' will run the configuration script, 
# but only if CONFIG.py doesn't already exist. 
# 
#  configure: $(CONFIGURATION)  

# CONFIG.py:
# 	bash ./configure
#	echo "Configuration complete"

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



