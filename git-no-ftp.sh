#!/bin/bash
HOST=[FTP host here]
USER=[FTP user name here]
PASS=[FPT Password]
LOCAL_ROOT=[Loca root of the git project with trailing slash]

cd $LOCAL_ROOT
# fetch all updated files and store to FILES variable.
FILES=$(eval "git fetch && git diff --name-only ..origin")

#Do pull
git pull

# Loop though the updated files
while read -r path; do
# Go to local path of the file
FILE_PATH=$LOCAL_ROOT$path
FILE_DIR=$(dirname "$FILE_PATH")
FILE=$(basename "$path")
REMOTE_FILE_DIR=$(dirname "$path")

# Go to local file directory
cd $FILE_DIR

# Do FTP upload
ftp -inv $HOST <<EOF
user $USER $PASS
passive
cd $REMOTE_FILE_DIR
put $FILE
bye
EOF
done <<< "$FILES"