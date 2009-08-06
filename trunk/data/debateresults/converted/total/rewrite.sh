#!/bin/bash

./schools.sh     | mysql -u admin && echo "schools done" &&
./tournaments.sh | mysql -u admin && echo "tournaments done" &&
./leagues.sh     | mysql -u admin && echo "leagues done" &&
./seeding.sh     | mysql -u admin && echo "seeding done" &&
./divisions.sh   | mysql -u admin && echo "divisions done" &&
./people.sh      | mysql -u admin && echo "people done" &&
./teams.sh       | mysql -u admin && echo "teams done" &&
./rounds.sh      | mysql -u admin && echo "rounds done" &&
./register.sh    | mysql -u admin && echo "register done"