#! /bin/bash
# 
# choose a configuration file:  
#     We install one of the CONFIG_machine.py files as ../CONFIG.py 
#     selecting by known host names (e.g., ix), architecture names
#     (e.g., armv7 or armv8 for pi), operating system (darwin for MacOSX). 
#     The default is chosen if none of the known architectures matches. 
#     Similarly one Makefile.local
#
# 

# What machine is this?  Use uname to find hardware
# 
architecture=`uname -m`
node=`uname -n`
processor=`uname -p`
opsys=`uname -v`

if [[ $architecture =~ "arm" ]]; then
   echo "Configuring for Raspberry Pi versions 2 or 3"
   cp CONFIG_standard.py ../CONFIG.py
   cp Makefile.standard ../Makefile.local

elif [[ $opsys =~ "Darwin" ]]; then 
   echo "Configuring for Mac OS X"
   cp CONFIG_standard.py ../CONFIG.py
   cp Makefile.standard ../Makefile.local

elif [[ $node =~ "ix" ]]; then 
   echo "Configuring for CIS host ix-trusty or ix-dev"
   cp CONFIG_ix.py ../CONFIG.py
   cp Makefile.unbuntu ../Makefile.local
   echo "You must editing CONFIG.py to use a different port"

else
   echo "Unknown host type; using default configuration files"
   echo "Edit CONFIG.py to set appropriate port"
   echo "Edit Makefile.in as needed"
   cp CONFIG.skel.py ../CONFIG.py
   cp Makefile.standard ../Makefile.local

fi;




