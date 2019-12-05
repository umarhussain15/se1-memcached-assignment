#!/bin/bash

# set path of dude and python for this script.
export PATH=$PATH:$HOME/local/bin
export PYTHONPATH=$PYTHONPATH:$HOME/local/lib/python

dude run
dude sum
Rscript graphs.R
