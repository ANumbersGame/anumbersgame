[The actual attendance numbers and the code used to generate them are available in the source repository.](http://code.google.com/p/anumbersgame/source/browse/trunk/tests/attendance/)

# Location #

There has been some discussion on edebate about the effect of the location of CEDA Nationals on that tournament's attendance. [[1](http://www.ndtceda.com/pipermail/edebate/2009-May/078672.html)] [[mirror 1](http://www.mail-archive.com/edebate@www.ndtceda.com/msg08871.html)] [[mirror 2](http://article.gmane.org/gmane.education.region.usa.edebate/9189)] [[2](http://www.ndtceda.com/pipermail/edebate/2009-May/078681.html)] [[mirror 1](http://www.mail-archive.com/edebate@www.ndtceda.com/msg08880.html)] [[mirror 2](http://article.gmane.org/gmane.education.region.usa.edebate/9198)]

I thought it might be interesting to compare past CEDA Nats attendance against past NDT district qualifying tournament attendance. Historical data on district qualifying tournament attendance is available for the years ending in 2004 through 2009, for all Districts except 2, 4, and 9. The comparison below is between the number of teams competing in those qualifiers and the number of teams at CEDA Nats.

<p align='center'>
<img src='http://chart.apis.google.com/chart?cht=lc&chs=700x400&chd=t:174,180,180,176,183,146|95,109,131,111,110,112&chds=50,200,50,200&chm=o,,0,-1,5|o,,1,-1,5&chdl=CEDA|NDT%20Districts&chxt=x,x,x,y&chxr=0,2004,2009,1&chxl=3:||75|100|125|150|175|200|2:|NDT%20Location|DC|Spokane|Evanston|Dallas|Fullerton|Austin|1:|CEDA%20Location|Louisville|San%20Francisco|Dallas|Norman|Wichita|Pocatello&&chxp=1,-20,0,20,40,60,80,100|2,-20,0,20,40,60,80,100&chco=ff0000a0,0000ffa0&chg=200,16.7&dummy=img.png' />
</p>

Note that there was a sharp drop off in CEDA attendance when it was in Pocatello. There was a similar increase for NDT district attendance when the NDT was in Evanston.

If there was a location-based disincentive travelling to the 2009 CEDA Nats, it may be even stronger than the chart above indicates, since total attendance may have been bolstered by the existence of a novice breakout. This would be tricky to measure. For more on novice participation, see below.

The use of district qualifier participation to model the overall number of teams willing to participate in national varsity tournaments is not perfect. There are many teams that go to CEDA Nats without any hope of qualifying for the NDT, and there are many teams that qualify for the NDT but skip CEDA Nats.

# Division #

To measure the strength of competitors attending CEDA Nats, we can check what divisions they debate in. For CEDA Nats from 2004 through 2008, we can look at each debater who attended in that year, then see what divisions he or she has chosen to debate in at other tournaments that year. 57% debated mainly in open divisions. For the remaining 43%, each tournament is weighted equally, then an average of each debater's division is produced. This is a histogram of CEDA Nats debaters per year with the given divisional average:

<p align='center'>
<img src='http://chart.apis.google.com/chart?cht=bvs&chs=400x300&chd=t:32,36,19,27,49,16,92,86,53,107,137,107&chds=0,150&chxt=x,y&chxr=1,0,30,10&chxl=0:|Novice|||Novice/JV|||JV|||JV/Open|||&dummy=img.png' />
</p>

2009's CEDA Nats had a novice breakout, which may have increased novice attendance. [There were at least 36 debaters with novice eligibility](http://www.ndtceda.com/pipermail/edebate/attachments/20090324/58805905/attachment-0002.pdf) [(mirror)](http://cache.gmane.org//gmane/education/region/usa/edebate/8697-003.bin), even though there were substantially fewer total teams in 2009 than in years past. We can get a fuller picture once the DebateResultsDotCom 2008-2009 database dump is available.

# NDT preference #

We might also ask which NDT teams skip CEDA Nats. The chart below uses the three years of NDT tournament results available on DebateResultsDotCom (2006-08) to calculate a 20-team running average of how often the team in each place at the NDT attends CEDA Nats. Place is calculated using [Bruschke's method](http://commweb.fullerton.edu/jbruschke/web/BruschkeExplanation.aspx):

> Obviously, first and second place are determined by who won the final round, third and fourth are determined by ranking the semi-finalists by normal criteria (prelim wins first, then adjusted points, then total points), fifth through eighth by ranking the quarter-finalists, and so on, finally ranking all the teams that didn't clear.

The method is modified to fit the [NDT standing rules](http://groups.wfu.edu/NDT/Documents/ndtrules.html), section V.C.2:

> The criteria for determining the seeding for elimination rounds shall be administered in the following order: (1) wins, (2) ballots, (3) adjusted combined speaker points (dropping high and low ballots), (4) continue dropping high and low ballots down to twelve remaining ballots, (5) flip of a coin.

A little over half of NDT teams attend CEDA Nats, and there is only a _very_ slight inverse correlation between NDT place and CEDA Nats attendance.

<p align='center'>
<img src='http://chart.apis.google.com/chart?cht=bvg&chbh=a&chm=D,,1,0,1&chbh=a&chs=400x300&chd=t1:2,3,1,1,1,1,1,1,2,3,2,1,1,2,3,2,3,3,2,2,0,1,1,0,2,1,3,2,2,3,2,1,3,2,2,3,1,2,0,2,0,1,3,2,1,0,2,2,3,1,2,2,1,2,1,3,2,1,1,0,2,0,1,2,3,2,2,1,1,2,1,2,2,2,0,2,1,2|-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,1.85,1.75,1.65,1.65,1.6,1.65,1.65,1.75,1.8,1.8,1.8,1.8,1.8,1.9,1.9,1.85,1.9,1.8,1.75,1.65,1.65,1.65,1.65,1.75,1.85,1.8,1.75,1.7,1.7,1.75,1.65,1.65,1.7,1.6,1.6,1.55,1.55,1.6,1.55,1.6,1.5,1.6,1.55,1.45,1.45,1.55,1.65,1.65,1.6,1.5,1.55,1.5,1.5,1.55,1.55,1.5,1.45,1.4,1.45,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0&chds=0,3,0,3&chxt=x,y&chxl=1:||25%|50%|75%|100%|0:|worst|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||best|&chco=FFFFAA&chma=0,30,0,0&chg=200,50.1,1,0&dummy=img.png' />
</p>

## Skipping CEDA to prep ##

In early 2009, Darren Elliott [asked the candidates for CEDA 2nd VP about the attendance of NDT first round recipients at CEDA Nats](http://www.ndtceda.com/pipermail/edebate/2009-January/077253.html). (mirrors: [[1](http://article.gmane.org/gmane.education.region.usa.edebate/7778)],[[2](http://www.mail-archive.com/edebate@www.ndtceda.com/msg07520.html)]). [Scott Elliott said that it was pretty obvious that NDT teams skipping CEDA did so because they were busy prepping for the NDT](http://www.ndtceda.com/pipermail/edebate/2009-January/077254.html). (mirrors: [[1](http://article.gmane.org/gmane.education.region.usa.edebate/7779)], [[2](http://www.mail-archive.com/edebate@www.ndtceda.com/msg07521.html)]) However, only 45 NDT teams attended CEDA Nats in 2006 (when the NDT preceded CEDA), while in the two following years 39 and 44 NDT teams went to CEDA.