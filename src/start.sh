#!/bin/bash

export FLASK_APP=flaskr
export FLASK_ENV=development

cd $HOME/startnet/src/
python3 -m venv venv
. venv/bin/activate
flask run &
