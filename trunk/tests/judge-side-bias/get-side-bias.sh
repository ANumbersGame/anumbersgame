#!/bin/sh

mysql --raw DebateResults0304 < sideDecPerJudge.mysql | ./JudgeSideBias > JudgeSideBias0304.txt
mysql --raw DebateResults0405 < sideDecPerJudge.mysql | ./JudgeSideBias > JudgeSideBias0405.txt
mysql --raw DebateResults0506 < sideDecPerJudge.mysql | ./JudgeSideBias > JudgeSideBias0506.txt
mysql --raw DebateResults0607 < sideDecPerJudge.mysql | ./JudgeSideBias > JudgeSideBias0607.txt
mysql --raw DebateResults0708 < sideDecPerJudge.mysql | ./JudgeSideBias > JudgeSideBias0708.txt