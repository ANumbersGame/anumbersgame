#!/bin/bash

URLBASE="http://anumbersgame.googlecode.com/svn/trunk/tests/team-rating/scc-visualize/"
THUMB=$1
THUMBURL=$(echo $THUMB | sed 's/ /\%20/g')
ORIGURL=${THUMBURL/thumbs\///}
NAME=${THUMB/thumbs\/DebateResults//}

cat <<EOF
<item>
<title>${NAME}</title>
<link>
${URLBASE}${ORIGURL}
</link>
<media:group>
<media:title type='plain'>${NAME}</media:title>
<media:content
url='${URLBASE}${ORIGURL}'
type='image/png'
medium='image'>
</media:content>
<media:thumbnail
 url='${URLBASE}${THUMBURL}'
>
</media:thumbnail>
</media:group>
</item>
EOF
