<html>
<head>
<title>Tournaments - A Numbers Game</title>
{include file='icon.tpl'}
</head>
<body>
<table border="1">
{foreach from=$tournaments item=tourn}
<tr>
<td>
<a href="series/{$tourn.aka|escape:'urlpathinfo'}/{$tourn.year|escape:'urlpathinfo'}/{$tourn.id|escape:'urlpathinfo'}">All</a>
</td>
{foreach from=$tourn.list item=ones}
<td>
{foreach from=$ones item=single}
{$single.name|escape:'htmlall':'UTF-8'|nl2br}
<br>
{/foreach}
</td>
{/foreach}
</tr>
{/foreach}
</table>
{include file='track.tpl'}
</body>
</html>
