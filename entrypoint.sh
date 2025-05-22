#!/bin/sh -l
# SPDX-FileCopyrightText: 2024 Datavolo Inc.
#
# SPDX-License-Identifier: Apache-2.0

java -jar /flow-diff.jar $1 $2 >> /github/workspace/diff.txt

OUTPUT=$(cat /github/workspace/diff.txt | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

#curl -X POST \
#     -H "Authorization: Token $3" \
#     -H "Accept: application/vnd.github+json" \
#     https://api.github.com/repos/$4/issues/$5/comments \
#     -d "{\"body\":\"$OUTPUT\"}"

PAYLOAD_FILE="/tmp/github_comment_payload_$(date +%s%N).json"

        # Construct the JSON payload and write it to the temporary file.
        # The 'body' field contains the escaped output from your JAR.
echo "{\"body\":\"$ESCAPED_OUTPUT\"}" > "$PAYLOAD_FILE"

        # Make the curl POST request to the GitHub API.
        # '--data-binary "@$PAYLOAD_FILE"' tells curl to read the request body
        # directly from the specified file, bypassing shell argument limits.
curl -X POST \
     -H "Authorization: Token $3" \
     -H "Accept: application/vnd.github+json" \
     "https://api.github.com/repos/$4/issues/$5/comments" \
     --data-binary "@$PAYLOAD_FILE"

        # Clean up the temporary payload file after the curl request is complete.
rm -f "$PAYLOAD_FILE"
