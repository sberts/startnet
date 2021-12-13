#!/bin/bash

cd $HOME/startnet/src/
python3 -m venv venv
. venv/bin/activate
flask run
