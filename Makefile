#
# Simple Makefile for first Flask project
#


##
## Install in a new environment:
##     We need to rebuild the Python environment to match
##     
install:
	pyvenv-3.4 env
	pip install -r requirements.txt

dist:
	pip freeze >requirements.txt

