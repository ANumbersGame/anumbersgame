#!/bin/bash

for YEAR in 0304 0405 0506 0607 0708
do
    cat >thumbs${YEAR}.rss <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<rss xmlns:media='http://search.yahoo.com/mrss/' version='2.0'>
  <channel>
    <title>ANumbersGame.net tournament charts</title>
    <description>College policy debate tournament charts.</description>
    <link>http://code.google.com/p/anumbersgame/wiki/TournamentCharts</link>
EOF

    find thumbs/DebateResults${YEAR} -iname '*.png' -exec ./rssItem.sh "{}" \; >>thumbs${YEAR}.rss
    echo "</channel></rss>" >>thumbs${YEAR}.rss
done
