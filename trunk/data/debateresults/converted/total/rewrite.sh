#!/bin/bash

mysql < mktables.sql && ./seeding.sh | mysql && ./divisions.sh | mysql && ./people.sh | mysql