#!/bin/bash

for YEAR in 0304 0405 0506 0607 0708
do
    cat >show${YEAR}.xml <<EOF
<?xml version="1.0" encoding="UTF-8" ?> 
<Module>
  <ModulePrefs title="hello world example" /> 
  <Content type="html">
     <![CDATA[ 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>Google AJAX Feed API - Slide Show Sample</title>
  <script src="http://www.google.com/jsapi/?key=internal-sample"
    type="text/javascript"></script>
  <script src="http://www.google.com/uds/solutions/slideshow/gfslideshow.js"
    type="text/javascript"></script>

  <style type="text/css">
    .gss a img {border : none;}
    .gss {
      width: 400px;
      height: 300px;
      color: #dddddd;
      background-color: #000000;
    }

  </style>
  <script type="text/javascript">
    function load() {
      var samples = "http://anumbersgame.googlecode.com/svn/trunk/tests/team-rating/scc-visualize/thumbs${YEAR}.rss";
      var options = {
        displayTime: 4000,
        transistionTime: 300,
    fullControlPanel : true,
        linkTarget : google.feeds.LINK_TARGET_BLANK,
    pauseOnHover : false
      };
      new GFslideShow(samples, "slideshow", options);
    }
    google.load("feeds", "1");
    google.setOnLoadCallback(load);
  </script>
</head>

<body>
  <div id="body">
    <div id="slideshow" class="gss">Loading..</div>
  </div>
</body>
</html>

     ]]>
  </Content> 
</Module>
EOF
done