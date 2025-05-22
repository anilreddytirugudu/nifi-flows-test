#!/bin/sh -l
# SPDX-FileCopyrightText: 2024 Datavolo Inc.
#
# SPDX-License-Identifier: Apache-2.0

java -jar /flow-diff.jar $1 $2 >> /github/workspace/diff.txt

OUTPUT=$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
JSON_PAYLOAD_FILE="/github/workspace/payload.json"
printf '{"body":"%s"}' "$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')" > "$JSON_PAYLOAD_FILE"
curl -X POST \
    -H "Authorization: Token $3" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/$4/issues/$5/comments" \
    -d "@$JSON_PAYLOAD_FILE"

# Clean up the temporary JSON payload file
rm "$JSON_PAYLOAD_FILE"

#curl -X POST \
#    -H "Authorization: Token $3" \
#   -H "Accept: application/vnd.github+json" \
#     https://api.github.com/repos/$4/issues/$5/comments \
#     -d "{\"body\":\"$OUTPUT\"}"


