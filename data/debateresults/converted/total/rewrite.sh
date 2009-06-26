#!/bin/bash

#./rounds.sh | mysql

#./teams.sh | mysql && ./rounds.sh | mysql

mysql < mktables.sql && ./seeding.sh | mysql && ./divisions.sh | mysql && ./people.sh | mysql && ./teams.sh | mysql && ./rounds.sh | mysql