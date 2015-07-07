<table align='center' border='0'>
<tr align='center'>
<td align='center'>
<wiki:gadget url="http://anumbersgame.googlecode.com/svn/trunk/tests/team-rating/scc-visualize/show0708.xml" width="400" height="300" border="0" /><br>
</td>
</tr>
<tr>
<td align='center'>Click on any image to view a full-sized version.<br>
</td>
</tr>
</table>

These are charts of the win-loss network in all 2007-2008 tournaments from DebateResultsDotCom. [Slideshows for earlier seasons are also available](TournamentWinLossNetworkCharts.md), and [individual tournament network charts are available in the repository](http://anumbersgame.googlecode.com/svn/trunk/tests/team-rating/scc-visualize/), as well as the Picasa links embedded in the above slideshow. The repository also includes the code for generating the charts.

# How to read the graphs #

In general, better teams are found at the top of the graph, colored green. Worse teams are at the bottom and in red. An arrow pointing from A to B means they had a debate and A won. The graphs ignore speaker points.

To be more specific, each node represents a **league**: a group of teams connected by the [transitive property](http://cfbanalyzer.com) [of wins](http://racarie.com/cftransitive). If A beat B, B beat C, and C beat A, they are all in the same league. (For details, see the next section)

In the charts above, leagues with only one member are labeled with the team name and their number of wins. Larger leagues get proportionally larger nodes, which are labeled with the least and most wins by any member of that league.

Nodes are colored by their win percentage: maroon is 0%, forest green is 100%.

For nodes representing leagues P and Q, there is an arrow from a P to Q when a member of P debated and beat a member of Q. Consistent with the definition of league, there is no cycle of arrows between a set of nodes.

Disconnected charts on one page represent the various divisions of the tournament. (novice, JV, open)

# What is a league? #

We say team A **indirectly beat** team B when either:

  * A beat B in a debate
  * There is a team C such that A beat C in a debate and C indirectly beat B

We say A and B are **indirectly tied** if A indirectly beat B and B indirectly beat A. A **league** is a maximal set of indirectly tied teams. That is, any two indirectly tied teams are in the same league. In the charts above, you can see than many leagues have only one member. Some tournaments have _no_ leagues with more than one member, and a few tournaments have only one league, meaning that every team is a member of it.

# Why make the charts? #

Tournament performance can be measured with any of a set of metrics FairBets. A good presentation of one version of the metric can be found in ["Ranking participants in generalized tournaments"](http://scholar.google.com/scholar?cluster=1588533582049225873), by Giora Slutzki and Oscar Volij.

The version they present (henceforth called **FBB**, for _FairBets bounty_) has many nice properties, but one of its weakness is that it can only produce rankings that preserve **dominance**, defined below. Dominance-preserving rankings may not be appropriate for debate tournaments.

To investigate this, I produced these charts.

# What is dominance? #

For every pair of leagues P,Q, either:

<dl>
<dt>P and Q are <b>incomparable</b></dt>
<dd>No team in P debated any team in Q</dd>
<dt>P <b>dominates</b> Q</dt>
<dd>In every debate between members of P and Q, the team from <b>P</b> won</dd>
<dt>Q <b>dominates</b> P</dt>
<dd>In every debate between members of P and Q, the team from <b>Q</b> won</dd>
</dl>

We say a league P **weakly dominates** a league Q when

  * P dominates Q
  * There is a league R such that P dominates R and R weakly dominates Q

When P weakly dominates Q, FBB ranks every team in P higher than every team in Q. When P and Q are incomparable, FBB does not produce a comparison between any team in P and any team in Q.

For intra- (rather than _inter-_) league ratings, FBB is much more sophisticated, producing not just _rankings_ (who is better than whom?) but _ratings_ (and how much better are they?). It gives an estimation of every team's odds against every other team, should they meet again. Furthermore, these odds are _fair_: had every team  in the league used these odds to bet on themselves in every league game, they all would have found themselves with the same amount of money they started with.

# Does normal tournament ranking respect dominance? #

No.

It's easy to find historical examples of tournaments where teams with lower win records dominate teams with higher win records.

<a href='http://anumbersgame.googlecode.com/svn/trunk/tests/team-rating/scc-visualize/DebateResults0607/George%20R%20R%20Pflaum%20Debate%20Tournament%20%20Emporia.png'><img width='90%' src='http://anumbersgame.googlecode.com/svn/trunk/tests/team-rating/scc-visualize/DebateResults0607/George%20R%20R%20Pflaum%20Debate%20Tournament%20%20Emporia.png'></img></a>

For example, at the Emporia debate tournament during the 2006-2007 season, KState BiHo dominates Oklhma DaZa, even though BiHo only has two wins and DaZa has four.

# Is FBB useful for ranking debate teams? #

Probably not for individual tournaments with more than one league.

I don't see a compelling reason why dominance should be valued over total number of wins. On the other hand, FBB might produce good rankings for tournaments with one league.

By the end of a debate season, nearly every team is in the same league, so FBB will be much more interesting in that case.