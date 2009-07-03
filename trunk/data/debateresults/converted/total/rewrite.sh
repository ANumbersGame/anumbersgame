#!/bin/bash

#./rounds.sh | mysql

#./teams.sh | mysql && ./rounds.sh | mysql

mysql -u admin < mktables.sql && ./seeding.sh | mysql -u admin && ./divisions.sh | mysql -u admin && ./people.sh | mysql -u admin && ./teams.sh | mysql -u admin && ./rounds.sh | mysql -u admin