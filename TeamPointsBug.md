# The following is an invalid bug report #

The explanation of my error was posted on [edebate](http://article.gmane.org/gmane.education.region.usa.edebate/9228) (mirrors: [[1](http://www.ndtceda.com/pipermail/edebate/2009-May/078711.html)] [[2](http://www.mail-archive.com/edebate@www.ndtceda.com/msg08910.html)]).

<font color='#CCCCCC'>
Cumulative results sheets at the NDT often misstate team points by a small amount, possibly due to a bug in <a href='http://www3.baylor.edu/~Richard_Edwards/TRPC.html'>Tab Room on the PC (TRPC)</a>. This has created incorrect seeding in NDT elimination rounds at least thrice in the past five years.<br>
<br>
<h2>How should NDT team points be calculated?</h2>

The <a href='http://groups.wfu.edu/NDT/Documents/ndtrules.html'>NDT standing rules</a> state:<br>
<br>
<blockquote>5.C.2. Seeding. The criteria for determining the seeding for elimination rounds shall be administered in the following order: (1) wins, (2) ballots, (3) adjusted combined speaker points (dropping high and low ballots), (4) continue dropping high and low ballots down to twelve remaining ballots, (5) flip of a coin.</blockquote>

To check that the cumulative sheets list incorrect team points, we need to see that they aren't listing "adjusted combined speaker points (dropping high and low ballots)" for any interpretation of that phrase. That phrase could mean:<br>
<br>
<ol><li>Adjust each speaker's speaker points by dropping one minimal and one maximal value, then sum these two adjusted scores.<br>
</li><li>Combine the two speakers' points into one pool, drop one minimal and one maximal value, then take the sum.<br>
</li><li>Combine the two speakers' points into one pool, drop <b>two</b> minimal and <b>two</b> maximal values, then take the sum.</li></ol>

To distinguish amongst these scores, I'll call them the <b>combined adjusted</b>, <b>adjusted combined</b>, and <b>doubly-adjusted combined</b> scores, respectively. "Combined adjusted score" should remind the reader that the adjusting was done before combining; what is combined are the adjusted scores. Similarly, the "adjusted combined score" adjusts points that have already been combined.<br>
<br>
Note that the adjusted combined score includes 46 values, while the other two scores include only 44.<br>
<br>
<h2>How are NDT team points calculated?</h2>

For about half of the teams I checked, the team score listed on the results sheet is the combined adjusted score. For a few of the teams, the team score is the doubly-adjusted combined score. For no team is the adjusted combined score listed; this score would be over 50 points higher due to its inclusion of two more values.<br>
<br>
For some teams, the results sheet gives a team score that matches none of the possible team scores listed above. As an example, at the 2009 NDT, Towson JM had the following speaker points:<br>
<br>
<table border='1'>
<tr><td> Jackson adjusted speaker points </td><td align='right'> 618.0  </td></tr>
<tr><td> Murray adjusted speaker points  </td><td align='right'> 622.0  </td></tr>
<tr><th> Combined adjusted points        </th><th align='right'> 1240.0 </th></tr>
<tr><td> Jackson total speaker points    </td><td align='right'> 674.0  </td></tr>
<tr><td> Murray total speaker points     </td><td align='right'> 679.0  </td></tr>
<tr><td> Combined total points           </td><td align='right'> 1353.0 </td></tr>
<tr><td> Adjusted combined points        </td><td align='right'> 1297.0 </td></tr>
<tr><th> Twice-adjusted combined points  </th><th align='right'> 1240.5 </th></tr>
<tr><th> Cumulative sheet team points    </th><th align='right'> 1239.5 </th></tr>
</table>

<p>
<h2>Seeding errors</h2>

I have checked the four NDTs for which there are cumulative sheets on the NDT website (2005, 2007-09), and I have found three seeding errors induced by badly-calculated speaker points:<br>
<br>
<table border='1'>
<tr>
<th> Year </th><th> Seed </th><th> Team </th><th> Sheet </th><th> Combined Adjusted </th><th> Twice-Adjusted Combined </th><th> Total </th><th> Adjusted Combined </th>
</tr><tr>
<td> 2009 </td><td align='center'> 28 </td><td align='center'> Berkeley BG </td><td align='center'> 1239.5 </td><td align='center'> 1239.0 </td><td align='center'> 1239.0 </td><td align='center'> 1351.5 </td><td align='center'> 1295.0 </td>
</tr>
<tr><td> 2009 </td><td align='center'> 29   </td><td align='center'> Towson JM       </td><td align='center'> 1239.5 </td><td align='center'> 1240.0            </td><td align='center'> 1240.5                  </td><td align='center'> 1353.0 </td><td align='center'> 1297.0            </td></tr>
<tr><td> 2007 </td><td align='center'> 5    </td><td align='center'> Northwestern BW </td><td align='center'> 1244.5 </td><td align='center'> 1244.5            </td><td align='center'> 1244.0                  </td><td align='center'> 1357.0 </td><td align='center'> 1300.5            </td></tr>
<tr><td> 2007 </td><td align='center'> 6    </td><td align='center'> Southern Cal IS </td><td align='center'> 1244.5 </td><td align='center'> 1245.0            </td><td align='center'> 1245.0                  </td><td align='center'> 1358.0 </td><td align='center'> 1301.5            </td></tr>
<tr><td> 2005 </td><td align='center'> 23   </td><td align='center'> Emory CG        </td><td align='center'> 1242.5 </td><td align='center'> 1243.0            </td><td align='center'> 1243.0                  </td><td align='center'> 1355.5 </td><td align='center'> 1299.0            </td></tr>
<tr><td> 2005 </td><td align='center'> 24   </td><td align='center'> Dartmouth BeM   </td><td align='center'> 1242.5 </td><td align='center'> 1243.5            </td><td align='center'> 1243.0                  </td><td align='center'> 1356.5 </td><td align='center'> 1300.0            </td></tr>
</table>

Each of these pairs should have reversed seeding. Many other teams had incorrectly calculated speaker point totals, but these did not affect seeding. I have not seen any errors of over one point, but each year several pairs of consecutive seeds are separated by an adjusted speaker point or less.<br>
<br>
I have not yet checked for errors in tournaments other than the NDT or for NDT years other than the four listed above.<br>
<br>
NDT cumulative sheets for the years I checked can be found at: <a href='http://groups.wfu.edu/NDT/Photos/NDT2009/2009PhotoCover.htm'>2009</a>, <a href='http://groups.wfu.edu/NDT/Photos/NDT%202008/2008PhotoCover.htm'>2008</a>, <a href='http://groups.wfu.edu/NDT/Photos/NDT2007/2007PhotoCover.htm'>2007</a>, <a href='http://groups.wfu.edu/NDT/Photos/2005NDT/2005PhotoCover.htm'>2005</a>.