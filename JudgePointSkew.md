# This page is just a draft #

<font color='#CCCCCC'>
Which judges give high points? "Whichever judges have given high average speaker points" is a simplistic answer to this simply-stated question. A better question might be "Which judges give higher points than the judging pool overall does to the same quality speeches?"<br>
<br>
Two or more judges don't give points to the same speeches except at the NDT and a few NDT district qualifying tournaments, so measuring this value directly is difficult. We could compare the points that a judge gives to a certain debater to the points that that debater earned over the course of the year. However, this doesn't account for debaters who change divisions or who improve from September to March. It also doesn't account for tournaments where the point average was higher or lower.<br>
<br>
To see whether a judge (Alice) gives higher points than her colleagues, let's compare the points given by Alice to the points given by other judges to the same debaters at the same tournaments at which Alice judged them.<br>
<br>
We'll compare these two groups with the Mann-Whitney U test, adjusted for ties, then rank judges by the deviation of this value from the expected distribution of U.<br>
<br>
<h1>Examples</h1>

Below are some point distributions for particular judges in particular divisions for the 2008-2009 season. The population distribution is gray, while the judge distribution is red or green. A red distribution is a judge who gives low points; a green distribution is a judge who gives high points. The <i>y</i>-axis represents the percentage of times a point value appears in a particular distribution. For the charts, point values are rounded to the half-point, and any points less than 24 are rounded up to 24. For both the charts and the calculation of the U value, speaker points over 30 are ignored; for 2008-2009, this is just Wake Forest's tournament and one or two data errors in the DebateResultsDotCom database.<br>
<br>
<h2>Bellwethers</h2>

JV Reed's point distribution is very similar to the rest of the pool; his U score is very close to the expected value. The same is true of Kris Willis.<br>
<br>
<table><thead><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000|3.1250,3.1250,5.4688,5.4688,23.4375,23.4375,34.3750,34.3750,27.3438,27.3438,5.4688,5.4688,0.7813,0.7813|25.0000,25.0000,25.5000,25.5000,26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000|0.0639,0.0639,0.0639,0.0639,0.0639,0.0639,1.0856,1.0856,8.5568,8.5568,22.2861,22.2861,35.2490,35.2490,24.1379,24.1379,7.7267,7.7267,0.7663,0.7663&chds=24,30.0,0,36,24,30.0,0,36&chco=00bb00,555555,ff0000,705000&chma=10,10,10,10&chtt=JV%20Reed|2009:%2032%20open%20debates|deviation:%200.03&chxt=y,x&chxr=0,0,36|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&dum.png' /> </th><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000|4.1667,4.1667,16.6667,16.6667,30.5556,30.5556,31.9444,31.9444,13.8889,13.8889,2.7778,2.7778|25.0000,25.0000,26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000,30.0000,30.0000|0.4902,0.4902,0.9804,0.9804,4.6569,4.6569,13.2353,13.2353,31.8627,31.8627,30.3922,30.3922,13.4804,13.4804,3.9216,3.9216,0.4902,0.4902,0.4902,0.4902&chds=24,30.0,0,33,24,30.0,0,33&chco=ff0000,555555,ff0000,705000&chma=10,10,10,10&chtt=Kris%20Willis|2009:%2018%20open%20debates|deviation:%20-0.21&chxt=y,x&chxr=0,0,33|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&img.png' /> </th></thead><tbody></tbody></table>

<h2>Doppelgängers</h2>

Not every low-deviation distribution, however, looks similar to the pool's distribution. The U score is roughly a measure of how likely it is that a score given by Alice (in this case, by Conor Cleary or by Brady Fletcher, respectively) is greater than a score given by the pool. This likelihood may be near 50% even if the distributions look quite different.<br>
<br>
<table><thead><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000|12.5000,12.5000,25.6579,25.6579,50.0000,50.0000,11.8421,11.8421|26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000,30.0000,30.0000|0.6140,0.6140,1.5789,1.5789,14.2982,14.2982,27.5439,27.5439,34.2982,34.2982,18.2456,18.2456,3.0702,3.0702,0.1754,0.1754,0.1754,0.1754&chds=24,30.0,0,51,24,30.0,0,51&chco=ff0000,555555,ff0000,705000&chma=10,10,10,10&chtt=Conor%20Cleary|2009:%2038%20open%20debates|deviation:%20-0.01&chxt=y,x&chxr=0,0,51|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&dum.png' /> </th><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000|2.5000,2.5000,7.5000,7.5000,28.7500,28.7500,46.2500,46.2500,6.2500,6.2500,8.7500,8.7500|24.0000,24.0000,24.5000,24.5000,25.0000,25.0000,25.5000,25.5000,26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000,30.0000,30.0000|1.8325,1.8325,0.2618,0.2618,2.6178,2.6178,0.5236,0.5236,9.4241,9.4241,7.0681,7.0681,25.9162,25.9162,18.0628,18.0628,19.6335,19.6335,7.8534,7.8534,4.4503,4.4503,1.5707,1.5707,0.7853,0.7853&chds=24,30.0,0,47,24,30.0,0,47&chco=00bb00,555555,ff0000,705000&chma=10,10,10,10&chtt=Brady%20Fletcher|2009:%2020%20novice%20debates|deviation:%200.09&chxt=y,x&chxr=0,0,47|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&dum.png' /> </th></thead><tbody></tbody></table>

<h2>Independents</h2>

High-deviation distributions also may look wildly different that the pool. John Nagy gives many more 27s than the pool, and Wynn Wilcox gives many more 29s.<br>
<br>
<table><thead><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000|4.1667,4.1667,12.5000,12.5000,50.0000,50.0000,25.0000,25.0000,2.7778,2.7778,4.1667,4.1667,1.3889,1.3889|26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000,30.0000,30.0000|2.7473,2.7473,4.0293,4.0293,14.1026,14.1026,23.2601,23.2601,29.8535,29.8535,16.8498,16.8498,7.8755,7.8755,0.7326,0.7326,0.5495,0.5495&chds=24,30.0,0,51,24,30.0,0,51&chco=ff0000,555555,ff0000,705000&chma=10,10,10,10&chtt=John%20Nagy|2009:%2018%20open%20debates|deviation:%20-7.87&chxt=y,x&chxr=0,0,51|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&dum.png' /> </th><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000|2.6316,2.6316,2.6316,2.6316,14.4737,14.4737,11.8421,11.8421,25.0000,25.0000,11.8421,11.8421,28.9474,28.9474,2.6316,2.6316|24.5000,24.5000,25.0000,25.0000,26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,30.0000,30.0000|0.2674,0.2674,1.3369,1.3369,4.2781,4.2781,6.4171,6.4171,25.9358,25.9358,27.8075,27.8075,20.3209,20.3209,9.6257,9.6257,3.4759,3.4759,0.5348,0.5348&chds=24,30.0,0,30,24,30.0,0,30&chco=00bb00,555555,ff0000,705000&chma=10,10,10,10&chtt=Wynn%20Wilcox|2009:%2019%20JV%20debates|deviation:%205.83&chxt=y,x&chxr=0,0,30|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&dum.png' /> </th></thead><tbody></tbody></table>

<h2>Shadows</h2>

Other high-deviation distributions looks like the pool, but shifted up or down a half-point. The open division debates judged during the 2008-2009 season by Jason Russell and Jonathan Paul are good examples of this shift.<br>
<br>
<table><thead><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:25.0000,25.0000,25.5000,25.5000,26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000|0.3788,0.3788,0.7576,0.7576,0.3788,0.3788,4.5455,4.5455,21.2121,21.2121,35.9848,35.9848,26.8939,26.8939,9.0909,9.0909,0.7576,0.7576|26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000,30.0000,30.0000|0.3450,0.3450,1.4661,1.4661,10.8236,10.8236,25.2264,25.2264,36.0500,36.0500,19.5343,19.5343,5.9508,5.9508,0.5175,0.5175,0.0862,0.0862&chds=24,30.0,0,37,24,30.0,0,37&chco=ff0000,555555,ff0000,705000&chma=10,10,10,10&chtt=Jason%20Russell|2009:%2066%20open%20debates|deviation:%20-8.74&chxt=y,x&chxr=0,0,37|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&img.png' /> </th><th> <img src='http://chart.apis.google.com/chart?cht=lxy&chs=420x270&chd=t:26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000|1.2821,1.2821,6.4103,6.4103,17.9487,17.9487,35.8974,35.8974,29.4872,29.4872,8.3333,8.3333,0.6410,0.6410|26.0000,26.0000,26.5000,26.5000,27.0000,27.0000,27.5000,27.5000,28.0000,28.0000,28.5000,28.5000,29.0000,29.0000,29.5000,29.5000,30.0000,30.0000|0.6289,0.6289,0.8648,0.8648,10.6918,10.6918,21.0692,21.0692,32.7044,32.7044,25.6289,25.6289,7.8616,7.8616,0.4717,0.4717,0.0786,0.0786&chds=24,30.0,0,37,24,30.0,0,37&chco=ff0000,555555,ff0000,705000&chma=10,10,10,10&chtt=Jonathan%20Paul|2009:%2039%20open%20debates|deviation:%20-7.9&chxt=y,x&chxr=0,0,37|1,24,30,1&chg=16.666666666667,0,3,3&chm=o,000000,0,-1,3|o,000000,1,-1,3&img.png' /> </th></thead><tbody></tbody></table>

</font>