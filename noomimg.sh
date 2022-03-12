#!/bin/bash
# Path: noomimg.sh
# copy image from clipboard and upload to s3

# a variable by the date and time
dateTime=$(date +%Y%m%d%H%M%S)
fileName="${dateTime}.png"
outputFile="/tmp/noom/${fileName}"
echo "The file name is: $fileName"
# output the clipboard content to fileName
# echo "$(pbpaste)" > "/tmp/noom/${fileName}"
# echo "$(xclip -o -selection clipboard)" > "/tmp/noom/${fileName}"
pngpaste ${outputFile}

echo "Noom image output finished"

echo "output file: ${outputFile}"
ls -l "${outputFile}"

#s3 aws s3 cp s3://dadior/demo-airflow-create-token.mov

# upload and grant permission to s3 bucket, overwrite the file
aws s3 cp "${outputFile}" "s3://dadior/${fileName}" --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

# fetch the url of the file
url=$(aws s3 presign "s3://dadior/${fileName}")

echo "The url of the file is: $url"

echo "refine the url:"
echo ${url} | sed -En "s/(https.*png)(.*)/\1/p"

echo "done!"
