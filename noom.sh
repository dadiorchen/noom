#!/bin/bash

# ask for input and store it in a variable
# echo "Enter file name: "
# read fileName

# execute a command and store the output in a variable
fileName=$(ls -t /Users/deanchen/Desktop/ | grep -e mov$ | head -n 1)

# replace .mov with .mp4
covertedFileName=${fileName/mov/mp4}

echo "The file you want to deal with is: $fileName"

# print start message
echo "Starting Noom..."

# calculate consuming time
start=$(date +%s)

inputFile="/Users/deanchen/Desktop/${fileName}"

outputFile="/tmp/noom/${covertedFileName}"

# execute command
~/soft/ffmpeg -y -i "${inputFile}" -preset ultrafast "${outputFile}"

# calculate consuming time
end=$(date +%s)
# calculate consuming time
diff=$(( $end - $start ))
echo "Noom finished in $diff seconds"

echo "output file: ${outputFile}"
ls -l "${outputFile}"

#s3 aws s3 cp s3://dadior/demo-airflow-create-token.mov

# upload and grant permission to s3 bucket, overwrite the file
aws s3 cp "${outputFile}" "s3://dadior/${covertedFileName}" --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

# fetch the url of the file
url=$(aws s3 presign "s3://dadior/${covertedFileName}")

echo "The url of the file is: $url"

echo "done!"