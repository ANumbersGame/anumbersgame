#!/bin/bash

mysql < mktables.sql && ./seeding.sh | mysql