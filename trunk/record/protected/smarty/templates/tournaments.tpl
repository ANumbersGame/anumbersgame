<html>
<head>
<title>Tournaments - A Numbers Game</title>
</head>
<body>
<table border="1">
{foreach from=$tournaments|smarty:nodefaults item=tourn}
<tr>
<td>All</td>
{foreach from=$tourn.list|smarty:nodefaults item=ones}
<td>
{foreach from=$ones|smarty:nodefaults item=single}
{$single.name}
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
