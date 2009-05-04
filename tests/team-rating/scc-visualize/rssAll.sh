#!/bin/bash

cat <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<rss xmlns:media='http://search.yahoo.com/mrss/' version='2.0'>
  <channel>
    <title>ANumbersGame.net tournament charts</title>
    <description>College policy debate tournament charts.</description>
    <link>http://code.google.com/p/anumbersgame/wiki/TournamentCharts</link>
EOF

find thumbs -iname '*.png' -exec ./rssItem.sh "{}" \;

echo "</channel></rss>"
