#
# Simple Makefile for first Flask project
#

# Configuration 
#
PYVENV = /usr/bin/env pyvenv-3.4  # This is the version in ix.cs.uoregon.edu

##
## Install in a new environment:
##     We need to rebuild the Python environment to match
##     
install:
	# pyvenv-3.4 env ### BUGGY on ix
	$(PYVENV) --without-pip env
	.  env/bin/activate
	curl https://bootstrap.pypa.io/get-pip.py | python
	pip install -r requirements.txt

dist:
	pip freeze >requirements.txt

