#!/bin/bash

###
# Restore some of the gtalug infrastructure in the cwd
###

restore_website(){
    WEBSITES_HOME=${HOME}/WebSites/
    RESTORE_DIR=${PWD}
    declare -A websites
    websites['org_gtalug_www']='https://github.com/gtalug/website.git'
    websites['org_gtalug_board']='git@github.com:gtalug/board-meetings.git'

    sudo apt-get install -y git python-virtualenv node-less python-dev jekyll
    for key in ${!websites[@]}
    do
        mkdir -p ${WEBSITES_HOME}
        git clone ${websites[${key}]}  ${WEBSITES_HOME}/${key}
        cd ${WEBSITES_HOME}/${key}
        virtualenv env
        source env/bin/activate
        pip install fabric
        if [ -f requirements.txt ]
        then
            pip install -r requirements.txt
            fab install
            fab run &
        else
            fab jekyll
        fi

    done
}


## Run all procedures

restore_website
