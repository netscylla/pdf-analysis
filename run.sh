#!/bin/bash

FILE=$1
PASSWD=$2

declare -a DEF_PASS=("1234","12345","123456","password","Password1","password123")

if [ -z $FILE ]
then
    echo "ERROR - No file argument found!"
    exit
fi

if [ -z $PASSWD ]
then
    echo "No password found, if encrypted cant proceed!"
fi

if [ ! -f $FILE ]; then
    echo "File not found!"
    exit
fi

is_encrypted=$(python ./pdfid.py ${FILE} |grep Encrypt|awk '{print $2}')

function extract_urls {
    echo "extracting URIs:"
    if [ -z $PASSWD ]
    then
        python ./pdf-parser.py -s /URI ${FILE} |grep http|awk '{print $2}'|grep -v Didier|tr -d "("|tr -d ")"    
    else
        if [ ! -f ${FILE}_2 ]
        then
            echo "something went wrong decrypted file not found!"
        else
            python ./pdf-parser.py -s /URI ${FILE}_2|grep http|awk '{print $2}' |grep -v Didier|tr -d "("|tr -d ")"
        fi
    fi
}

if [ $is_encrypted -ge 1 ] 
then
    echo "PDF is encrypted..."
    echo "trying password..."
    if [ -z $PASSWD ]
    then
        echo "Trying default passwords"
        for i in "${DEF_PASS[@]}"
        do
            qpdf --decrypt --password=$i ${FILE} ${FILE}_2
        done
    else
        qpdf --decrypt --password=$PASSWD ${FILE} ${FILE}_2
    fi
    if [ -z ${FILE}_2 ]
    then
        echo "something went wrong, cant find decrypted file"
    else
        echo "Valid Password, continuing..."
        extract_urls
    fi
else
    echo "PDF not encrypted, continuing analysis..."
    extract_urls
fi
