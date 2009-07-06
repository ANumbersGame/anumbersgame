<html>
<head>
<title>Tournament series error - A Numbers Game</title>
{include file='icon.tpl'}
</head>
<body>
<h1>Tournament series not found!</h1>
<h2>An error has been reported.</h2>
{if isset($akaGrp) && count($akaGrp) > 0}
<p>
<a href="{$webroot|escape:'urlpathinfo':'UTF-8'}/tournaments/series/{$smarty.get.aka|escape:'urlpathinfo':'UTF-8'}/{$akaGrp.0.year|escape:'urlpathinfo':'UTF-8'}/{$akaGrp.0.id|escape:'urlpathinfo':'UTF-8'}">Did you mean the series:</a>

<table border="1">
<tr><th>date</th>
  <th>name</th>
  <th>host</th></tr>

{foreach from=$akaGrp item=trn}
<tr>
<td>{$trn.start|escape:'htmlall':'UTF-8'|nl2br}</td>
<td>{$trn.name|escape:'htmlall':'UTF-8'|nl2br}</td>
<td>{$trn.sname|escape:'htmlall':'UTF-8'|nl2br}</td>
</tr>
{/foreach}

</table>

{/if}


{if isset($altAkaGrp) && count($altAkaGrp) > 0}
<p>
<a href="{$webroot|escape:'urlpathinfo':'UTF-8'}/tournaments/series/{$altAka|escape:'urlpathinfo':'UTF-8'}/{$altAkaGrp.0.year|escape:'urlpathinfo':'UTF-8'}/{$altAkaGrp.0.id|escape:'urlpathinfo':'UTF-8'}">Did you mean the series:</a>


<table border="1">
<tr><th>date</th>
  <th>name</th>
  <th>host</th></tr>

{foreach from=$altAkaGrp item=trn}
<tr>
<td>{$trn.start|escape:'htmlall':'UTF-8'|nl2br}</td>
<td>{$trn.name|escape:'htmlall':'UTF-8'|nl2br}</td>
<td>{$trn.sname|escape:'htmlall':'UTF-8'|nl2br}</td>
</tr>
{/foreach}

</table>

{/if}

{include file='track.tpl'}
</body>
</html>
