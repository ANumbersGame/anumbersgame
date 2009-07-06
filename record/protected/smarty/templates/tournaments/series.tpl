<html>
<head>
<title>{$name|escape:'htmlall':'UTF-8'|nl2br}</title>
{include file='icon.tpl'}
</head>
<body>
<p>
{if isset($att)}
<img src="http://chart.apis.google.com/chart?cht=lxy
&chs=450x350
&{$att}
&{$scal}
&chco=008000,0000ff,ff0000,705000
&chm
=o,008000,0,-1,12,1
|o,0000ff,1,-1,11,1
|o,ff0000,2,-1,10,1
|o,705000,3,-1,9,1
&chma=10,10,10,10
&chtt={$name|escape:'urlpathinfo':'UTF-8'}|teams attending
&{$labs}
&chxt=x,y
&chxr=1,0,{$maxdiv},{$rang}
&chg=0,{math equation='100*r/md' r=$rang md=$maxdiv},1,0
&chls=1,2,9|
1,2,10|
1,2,11|
1,2,8
&{$years}">
<p>This chart counts teams in collapsed divisions as participants in the higher division.
{/if}
{*
{math equation='100/ny' ny=$numyears}
*}
{include file='track.tpl'}
</body>
</html>
