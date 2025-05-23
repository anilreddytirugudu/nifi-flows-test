#!/bin/sh -l
# SPDX-FileCopyrightText: 2024 Datavolo Inc.
#
# SPDX-License-Identifier: Apache-2.0

java -jar /flow-diff.jar $1 $2 >> /github/workspace/diff.txt

#OUTPUT=$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')


# Clean up the temporary JSON payload file

#curl -X POST \
#    -H "Authorization: Token $3" \
#   -H "Accept: application/vnd.github+json" \
#     https://api.github.com/repos/$4/issues/$5/comments \
#     -d "{\"body\":\"$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')\"}"

echo "{\"body\":\"$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')\"}"
echo "{\"body\":\"$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')\"}" > /tmp/github_comment_payload.json

# Send the POST request, reading the payload from the temporary file
curl -X POST \
  -H "Authorization: Token $3" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$4/issues/$5/comments" \
  -d @/tmp/github_comment_payload.json

# Clean up the temporary JSON payload file
rm /tmp/github_comment_payload.json
