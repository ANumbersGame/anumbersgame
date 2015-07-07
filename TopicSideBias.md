There is discussion every summer about the side bias of prospective controversy areas and resolutions. Using the data from DebateResultsDotCom, we can see what side bias past resolutions have exhibited.

# Methodology #

## Counting ballots ##

One way to measure if a topic was biased towards the aff or the neg is to simply check the number of ballots that went aff. There is a confounding variable of team ability, though, since power matching at tournaments is a very rough way to match teams of equal ability. The large number of rounds between teams of very unequal ability may swamp any topic bias visibility.

Consider a season conducted by `n` pairs of teams such that:

  * Every team debates every other team some large number of times
  * In debates between teams from pair `i` and pair `i+1`, the team from pair `i` wins 90% of the time, regardless of side
  * In debates between teams from pair `i` and pair `i+k` where `k > 1`, the team from pair `i` wins almost 100% of the time, regardless of side
  * When two teams from the same pair debate, the affirmative wins 90% of the time

This season exhibits large differences between teams in different pairs. These differences swamp the strong aff bias between equally matched teams: as the number of teams gets larger, the total percentage of rounds won by the neg gets closer to `50%`, even though any team would be wise to flip aff.

## Bradley-Terry ##

If we account for team quality, we can more accurately measure topic side bias. This has been done before with home-field advantage and presentation order using the **Bradley-Terry** model for paired comparisons.

In the basic Bradley-Terry model, it is assumed that teams `i` and `j` have intrinsic abilities `pi` and `pj`. The total ability in a debate between the two is `pi+pj`, and the probability that `i` wins is equal to `i`'s total share of the ability displayed: `pi/(pi+pj)`. This model is a [very popular](http://scholar.google.com/scholar?q=%22bradley-terry%22) way of measuring preferences in scientific experiments. It has been reinvented at least three times since the [original invention in 1929 by Zermelo](http://scholar.google.com/scholar?cluster=10348565627147554444): by [Bradley and Terry in 1952](http://scholar.google.com/scholar?cluster=3342470457888860512), by [Ford in 1957](http://scholar.google.com/scholar?cluster=17948963708584189499), and by [Jech in 1983](http://scholar.google.com/scholar?cluster=11957541490945283103). It is sometimes called the Bradley-Terry-Luce model, the Zermelo model, or maximum likelihood (which is actually a way of estimating the parameters of the model, rather than the model itself, see [Brozos-Vazquez et al.](http://scholar.google.com/scholar?cluster=1976262193035074609) and [Stob](http://scholar.google.com/scholar?cluster=5491505416511234457)).

In the model of Bradley-Terry that accounts for side bias, there is assumed to be a parameter `t` such that the probability of `i` beating `j` is `(t*pi)/(t*pi + pj)` when `i` is aff. In other words, `t` is a measure of the amplification of a team's ability by being affirmative. A `t` of `1.23` is a 23% amplifier for the affirmative. (This does _not_ increase the aff win percentage to `73% = 50% + 23%`. If all teams were equally matched, a 23% aff amplifier would induce a `1.23/2.23 = 55.2%` aff win percentage. For more on how to interpret the bias percentage, see the "Discussion" section below.)

In the example from the previous section, when there are 20 pairs of teams and each team debates each other team 20 times, the affirmative wins 51.0% of the rounds. If we ignore team quality, this implies an aff amplifier of 4.2%. After accounting for team quality, the Bradley-Terry method finds an aff amplifier of 116.3%

After calculating the parameter `t`, one can decide whether there is a side bias based on `t`'s distance from 1 and by how much more accurate the model is when accounting for side bias. For more details, see [Davidson and Beaver's "On extending the Bradley-Terry model to incorporate within-pair order effects"](http://scholar.google.com/scholar?cluster=6050716066748286974) and [Hunter's "MM algorithms for generalized Bradley-Terry models"](http://scholar.google.com/scholar?cluster=1036704245272414243) as well as the [code used to generate the data below](http://code.google.com/p/anumbersgame/source/browse/trunk/tests/fair-bets).

The basic idea is to compare how much better the model fits the data after adding a side bias parameter. Adding _any_ parameter to the model will improve the fit, but adding parameters that are essentially random should improve the fit much less. For instance, if we added an amplifier parameter for teams with an odd number of vowels in their last names, we would expect the model to fit the data only slightly better. Comparing the improvement when using the side-biased model with the expected improvement when using a model that adds no real predicative power over the basic Bradley-Terry model, we can obtain an estimate of the probability that the side bias parameter `t` is no better than a random amplifier. Three of the topics in the past six years have side bias that would occur by chance less than once every thousand times. The other three years have side bias that would occur by chance more than once every ten times.

The results are given as intervals around a percentage. The percentage is `100*(t-1)` when `t > 1` (indicating an aff advantage), or `100*(1/t -1)`  when `t < 1` (indicating neg advantage). The confidence interval indicates the side biases that are indistinguishable from `t` at the `p = .10` confidence level. This is calculated using the likelihood-ratio test, following Davidson and Beaver.

# Results #

Thar charts below show the side bias values for which the Bradley-Terry rankings are statistically indistinguishable from the most likely side bias. The yellow line traces the maximum likelihood estimates of the side bias.

The energy, China, and security guarantee topics have small, yet highly statistically significant (`p < .001`), negative topic bias. Three other topics show no statistically significant bias either way. The nuclear arsenal topic shows a bias on the edge of statistical significance.

None of this data analysis would be possible without the excellent work done by Jon Bruschke at DebateResultsDotCom.

![http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.665,0.669|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-4.3,-16.8,-12.2,-2.1,-14.5,-7.3,0.9|4.3,-8.2,-3.8,6.0,-6.2,0.4,8.6|-0.0,-12.4,-8.0,1.9,-10.3,-3.4,4.7&chds=-20,10,-20,10,-20,10&chxt=x,x,y,y,x&chxl=2:|||10%25%20neg||even||10%25%20aff|0:|03-04|04-05|05-06|06-07|07-08|08-09|09-10|1:|Europe|energy|China|courts|security|agriculture|nuclear|4:|||||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|90%25+confidence+interval&chg=0,33.33,4,3,0,0&chdlp=t&dummy=img.png](http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.665,0.669|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-4.3,-16.8,-12.2,-2.1,-14.5,-7.3,0.9|4.3,-8.2,-3.8,6.0,-6.2,0.4,8.6|-0.0,-12.4,-8.0,1.9,-10.3,-3.4,4.7&chds=-20,10,-20,10,-20,10&chxt=x,x,y,y,x&chxl=2:|||10%25%20neg||even||10%25%20aff|0:|03-04|04-05|05-06|06-07|07-08|08-09|09-10|1:|Europe|energy|China|courts|security|agriculture|nuclear|4:|||||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|90%25+confidence+interval&chg=0,33.33,4,3,0,0&chdlp=t&dummy=img.png)

The charts below restrict the considered ballots to progressively smaller subsets, so the statistical confidence of side bias tends to be lower. The larger shaded regions indicate larger uncertainty about side bias.

![http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.634,0.638|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-17.4,-30.1,-19.2,-5.7,-10.5,0,4.7|7.9,-8.5,-3.2,8.0,3.3,15.2,18.9|-4.4,-18.7,-11.0,1.1,-3.4,7.4,11.6&chds=-35,20,-35,20,-35,20&chxt=x,x,y,y,x&chxl=2:||30%25%20neg||20%25%20neg||10%25%20neg||even||10%25%20aff||20%25%20aff|0:|03-04|04-05|05-06|06-07|07-08|08-09|09-10|1:|Europe|energy|China|courts|security|agriculture|nuclear|4:|||||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|in+open+divisions+with+>60+teams|90%25+confidence+interval&chg=0,18.18,4,3,0,9.09&chdlp=t&dummy=img.png](http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.634,0.638|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-17.4,-30.1,-19.2,-5.7,-10.5,0,4.7|7.9,-8.5,-3.2,8.0,3.3,15.2,18.9|-4.4,-18.7,-11.0,1.1,-3.4,7.4,11.6&chds=-35,20,-35,20,-35,20&chxt=x,x,y,y,x&chxl=2:||30%25%20neg||20%25%20neg||10%25%20neg||even||10%25%20aff||20%25%20aff|0:|03-04|04-05|05-06|06-07|07-08|08-09|09-10|1:|Europe|energy|China|courts|security|agriculture|nuclear|4:|||||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|in+open+divisions+with+>60+teams|90%25+confidence+interval&chg=0,18.18,4,3,0,9.09&chdlp=t&dummy=img.png)

![http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.498,0.502|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-50.2,3.8,-4.2,-7.3,-5.7|-10.9,39.3,27.5,22.5,24.7|-29.1,20.3,10.6,6.8,8.6&chds=-55,55,-55,55,-55,55&chxt=x,x,y,y,x&chxl=2:||50%25%20neg||40%25%20neg||30%25%20neg||20%25%20neg||10%25%20neg||even||10%25%20aff||20%25%20aff||30%25%20aff||40%25%20aff||50%25%20aff||0:|05-06|06-07|07-08|08-09|09-10|1:|China|courts|security|agriculture|nuclear|4:|||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|at+the+NDT|90%25+confidence+interval&chg=0,9.09,4,3,0,4.50&chdlp=t&dummy=img.png](http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.498,0.502|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-50.2,3.8,-4.2,-7.3,-5.7|-10.9,39.3,27.5,22.5,24.7|-29.1,20.3,10.6,6.8,8.6&chds=-55,55,-55,55,-55,55&chxt=x,x,y,y,x&chxl=2:||50%25%20neg||40%25%20neg||30%25%20neg||20%25%20neg||10%25%20neg||even||10%25%20aff||20%25%20aff||30%25%20aff||40%25%20aff||50%25%20aff||0:|05-06|06-07|07-08|08-09|09-10|1:|China|courts|security|agriculture|nuclear|4:|||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|at+the+NDT|90%25+confidence+interval&chg=0,9.09,4,3,0,4.50&chdlp=t&dummy=img.png)

![http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.498,0.502|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-32.6,-47.0,-29.6,-18.8,-11.5,-11.6,-34.1|3.6,-8.5,0,9.5,12.9,16.5,0.8|-13.1,-26.2,-13.8,-4.2,0.6,2.2,-15.4&chds=-55,55,-55,55,-55,55&chxt=x,x,y,y,x&chxl=2:||50%25%20neg||40%25%20neg||30%25%20neg||20%25%20neg||10%25%20neg||even||10%25%20aff||20%25%20aff||30%25%20aff||40%25%20aff||50%25%20aff||0:|03-04|04-05|05-06|06-07|07-08|08-09|09-10|1:|Europe|energy|China|courts|security|agriculture|nuclear|4:|||||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|among+first-round+applicants|90%25+confidence+interval&chg=0,9.09,4,3,0,4.5&chdlp=t&dummy=img.png](http://chart.apis.google.com/chart?cht=lc&chs=500x350&chm=b,0000ffaa,0,1,1|r,ff0000,0,0.498,0.502|o,000000,2,-1,5,1|o,000000,0,-1,5,1|o,000000,1,-1,5,1&chd=t:-32.6,-47.0,-29.6,-18.8,-11.5,-11.6,-34.1|3.6,-8.5,0,9.5,12.9,16.5,0.8|-13.1,-26.2,-13.8,-4.2,0.6,2.2,-15.4&chds=-55,55,-55,55,-55,55&chxt=x,x,y,y,x&chxl=2:||50%25%20neg||40%25%20neg||30%25%20neg||20%25%20neg||10%25%20neg||even||10%25%20aff||20%25%20aff||30%25%20aff||40%25%20aff||50%25%20aff||0:|03-04|04-05|05-06|06-07|07-08|08-09|09-10|1:|Europe|energy|China|courts|security|agriculture|nuclear|4:|||||guarantee||arsenal|3:||bias|&chco=000000,000000,ffff00&chtt=Topic+side+bias|among+first-round+applicants|90%25+confidence+interval&chg=0,9.09,4,3,0,4.5&chdlp=t&dummy=img.png)

# Discussion #

The percent bias numbers _do not_ indicate a team's increased probability of winning; a 10% neg bias does not mean the neg will win 55% of otherwise evenly matched rounds, or 88% of otherwise 80%-neg rounds. It means the neg's strength is amplified by 10%.

As an example, if the neg bias amplifier is 10%:

| **Aff team strength** | **Neg team strength** | **Neg wins with unbiased topic** | **Neg wins with 10% neg biased topic** |
|:----------------------|:----------------------|:---------------------------------|:---------------------------------------|
| 99                    | 1                     | 1%                               | 1.10%                                  |
| 1                     | 99                    | 99%                              | 99.09%                                 |
| 50                    | 50                    | 50%                              | 52.38%                                 |

**The largest side bias in the past seven years was the 12.37% neg bias on the energy topic. With this neg bias, in an otherwise evenly matched round, the neg has only a 52.91% chance of winning.**

The side bias in the past seven years, though highly statistically significant for three  years, is not very large. Statistically significance does not imply significance in everyday life. **With a large number of trials, even small effects can be statistically significant, and the DebateResultsDotCom database contains 115,237 ballots.** Statistical significance does not imply that the topic committee should change their focus, or that elims should be paired differently, or that judges should change their decision calculus.

Smaller samples can exhibit large biases that are not statistically significant. Generally, no confidence level less than 95% is considered statistically significant.

# Prior work #

In addition to the discussion every summer about the side bias of prospective topics, there has also been some number crunching and speculation about whether tournament results show any side bias:

  * [Will Repko warned](http://www.ndtceda.com/pipermail/edebate/2007-March/070404.html) that if the neg bias he saw in the late elims of the CEDA national tournament on the '06-'07 courts topic were not abated by changes in judging standards or the adoption of side equalization, "we may soon see a day where all the octas (and beyond) go neg." ([mirror 1](http://article.gmane.org/gmane.education.region.usa.edebate/990), [mirror 2](http://www.mail-archive.com/edebate@www.ndtceda.com/msg00902.html), [mirror 3](http://osdir.com/ml/education.region.usa.edebate/2007-03/msg00382.html))
  * [In response to Will Repko, Gary Larson crunched](http://www.ndtceda.com/pipermail/edebate/2007-March/070410.html) the numbers on CEDA nationals side bias, finding little evidence of negative side bias, adding that "While there is an undeniable temptation to write topics so that no side bias appears to occur in the last seven rounds of a tournament, the topic must also effectively serve the 100's of teams that will be debating it during the year." ([mirror 1](http://osdir.com/ml/education.region.usa.edebate/2007-03/msg00388.html), [mirror 2](http://www.mail-archive.com/edebate@www.ndtceda.com/msg00908.html), [mirror 3](http://article.gmane.org/gmane.education.region.usa.edebate/996))
  * [Ryan Galloway explained](http://www.ndtceda.com/pipermail/edebate/2001-October/035749.html) that a small side bias isn't as worrisome as the educational sacrifices made to correct side bias, with a caveat that some past topics had side biases that were too large to ignore.
  * [Later, Ryan Galloway speculated](http://www.ndtceda.com/pipermail/edebate/2001-October/035737.html) that the alternative to slight neg bias might be massive aff bias.
  * [Arnie Madsen suggested](http://www.ndtceda.com/pipermail/edebate/1997-October/000956.html) measuring side bias by restricting analysis to weed out confounding factors; in particular, he suggested comparing "win-loss percentage on this topic to previous years by examining results in non-side constrained power matched debates, and elimination round debates, at the same tournaments in this and previous years"
  * [Ryan Galloway listed](http://www.ndtceda.com/pipermail/edebate/2003-June/049812.html) 14 years of NDT final round results, finding a large aff bias.
  * [Terrance Shuman contrasted](http://www.ndtceda.com/pipermail/edebate/2003-June/049814.html) Galloway's list with the overall NDT elim results, finding less evidence for aff bias. [He later provided](http://www.ndtceda.com/pipermail/edebate/2003-June/049838.html) even more NDT elim numbers showing little side bias.
  * [Ede Warner compared](http://www.ndtceda.com/pipermail/edebate/2006-May/067145.html) aff advantage to home-field advantage, and questioned whether the topic committee should focus on neutralizing side bias. He also called for keeping records on side bias if the topic committee is tasked with reducing it.
  * [The Debater's Choice Awards, 2007](http://article.gmane.org/gmane.education.region.usa.edebate/1363), an opt-in email poll of college debaters conducted in April 2007, asked: (Alternate links: [1](http://www.cross-x.com/vb/showthread.php?p=1451260) [2](http://osdir.com/ml/education.region.usa.edebate/2007-04/msg00331.html) [3](http://debate-central.ncpa.org/forum/viewtopic.php?id=32544&action=new) [4](http://www.mail-archive.com/edebate@www.ndtceda.com/msg01256.html) [5](http://www.ndtceda.com/pipermail/edebate/2007-April/070777.html))
<blockquote>
39. Do you perceive a negative side bias in contemporary intercollegiate debate?</li></ul>

YES, 45 votes<br>
<br>
NO, 21 votes<br>
<br>
<br>
40. Do you believe that the topic committee should aim to craft resolutions that would attempt to increase the Affirmative win percentage?<br>
<br>
NO, 37 votes<br>
<br>
YES, 28 votes<br>
</blockquote>
<ul><li>In an attempt to dispel unsubstantiated whining in theory debates, [Ryan Ricard collected](http://lucydebate.blogspot.com/2008/10/terrible-arguments-now-with-data.html) win percentages from a few high school tournaments on the 2008-2009 energy topic, noting: "Come on people. It's the 21st century here. Quit making statistical claims without statistics." He found a slight neg bias.
  * [Nick Bubb analyzed](http://www.wiforensics.com/2006/12/are-debate-topics-fair-a-statistical-analysis/) the 2006 Wisconsin state high school debate tournament, finding no statistical evidence for side bias in 60 rounds of LD and 60 rounds of policy
  * [There was a long discussion](http://www.cross-x.com/vb/showthread.php?p=1485132) about side bias on the cross-x.com message board.

# Comparison to Copeland Contenders #

As a sanity check that the Bradley-Terry ratings correspond with conventional wisdom on team strength, we can compare the BT ratings (with and without side bias correction) to the [top five first-round teams](http://groups.wfu.edu/NDT/HistoricalLists/copeland.html). (N.B.: The first-rounds were ranked in mid-February, while the Bradley-Terry ratings are based on the entire season.)

The column labeled "Bradley-Terry rating" is just a team's score, `pi` (see the "Methodology" section above). The "Bradley-Terry with side bias rating" is a teams score `pi` under the most likely side bias amplifier. These scores can take on any positive number.

It is not particularly fruitful to compare scores from different years. They roughly correspond to how strong a team is compared to the field, but a Copeland contender can have their score inflated by more novice recruitment, which would make them stronger in comparison.

You can click on a column header to re-order the teams based on the data in that column.

If you can't view the tables below, try [viewing the whole spreadsheet as HTML](http://spreadsheets.google.com/pub?key=tyy2QYpZR7FxljzJScLZBPQ&output=html) or [logging in to Google Docs](http://docs.google.com/).

## 2009-2010, nuclear arsenal: estimated 4.7% aff bias, barely statistically significant with `p = 0.044` ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="330" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?range=A1:F8&headers=1&key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&gid=7" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>

## 2008-2009, agriculture: no statistically significant topic bias ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="290" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&range=A1:F7&gid=5&headers=-1" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>

## 2007-2008, security guarantee: estimated 10.3% neg bias, statistically significant with `p < 1/40,000` ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="340" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?range=A1:F7&headers=-1&key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&gid=4" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>

## 2006-2007, courts: no statistically significant topic bias ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="270" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&range=A1:F6&gid=3&headers=-1" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>

## 2005-2006, China: estimated 8.0% neg bias, statistically significant with `p < 1/1000` ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="290" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&range=A1:F8&gid=2&headers=-1" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>

## 2004-2005, energy: estimated 12.4% neg bias, statistically significant with `p < 1/1,000,000` ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="360" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?range=A1:F9&headers=1&key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&gid=0" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>

## 2003-2004, Europe: no statistically significant topic bias ##

<wiki:gadget url="http://www.google.com/ig/modules/simple-table.xml" height="290" width="850" border="0" up\_\_table\_query\_url="http://spreadsheets.google.com/tq?key=0Ar\_\_ITZ\_kU5fdHl5MlFZcFpSN0Z4bGp6SlNjTFpCUFE&range=A1:F6&gid=1&headers=-1" up\_\_table\_query\_refresh\_interval="300" up\_disableHtml="0"/>