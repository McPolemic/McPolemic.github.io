#!/bin/sh
LAST_POST=$(basename --multiple _posts/*weeknotes* | sort | tail -1)
LAST_DATE=$(echo $LAST_POST | cut -d - -f 1-3)
LAST_NUMBER=$(echo $LAST_POST | cut -d - -f 5 | sed 's/.md$//')

NEW_NUMBER=$((LAST_NUMBER + 1))
NEW_DATE=$(date --date="$LAST_DATE +7 days" --iso-8601)
NEW_POST="_posts/${NEW_DATE}-weeknotes-${NEW_NUMBER}.md"

cat << EOF > $NEW_POST
---
layout: post
title: Weeknotes ${NEW_NUMBER} - <TITLE>
date: ${NEW_DATE}
---
* <Point 1>
* <Point 2>
* <Point 3>
EOF

echo "Created new weeknotes post: ${NEW_POST}"
