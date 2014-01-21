<?php session_start(); ?><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<title>RoboRoom Control Center v0.1a</title>


<!-- Libraries -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
<script src="scripts/controls.js" type="text/javascript"></script>
<script src="scripts/gup.js" type="text/javascript"></script>

<!-- Flash -->
<!--script type="text/javascript" src="swfobject.js"></script-->
<!--script type="text/javascript" src="turkit-lib.js"></script-->
<!--script type="text/javascript" src="roboTurk.js"></script-->
<script type="text/javascript"> 
            var swfVersionStr = "10.1.0";
            var xiSwfUrlStr = "playerProductInstall.swf";
            var flashvars = {};
            var params = {};
            params.quality = "high";
            params.bgcolor = "#ffffff";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            var attributes = {};
            attributes.id = "KeyStream";
            attributes.name = "KeyStream";
            attributes.align = "middle";
            swfobject.embedSWF(
                "KeyStream.swf", "flashContent", 
                "640", "480", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
			swfobject.createCSS("#flashContent", "display:block;text-align:left;");
</script>

<!-- Style -->
<link rel="stylesheet" type="text/css" href="style.css"></link>

</head>

<body>

  Control away! (To control the robot, press W/A/S/D while on this page. Check in dev console for feedback if you don't have a robot connected to see the effect!)


  <div id="flashContent">
    <p>This HIT requires Flash Player 10.1 or newer.</p>
  </div>


        <noscript>
          <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="640" height="480" id="KeyStream">
              <param name="movie" value="KeyStream.swf" />
              <param name="quality" value="high" />
              <param name="bgcolor" value="#ffffff" />
              <param name="allowScriptAccess" value="sameDomain" />
              <param name="allowFullScreen" value="true" />
              <!--[if !IE]>-->
              <object type="application/x-shockwave-flash" data="KeyStream.swf" width="640" height="480">
                  <param name="quality" value="high" />
                  <param name="bgcolor" value="#ffffff" />
                  <param name="allowScriptAccess" value="sameDomain" />
                  <param name="allowFullScreen" value="true" />
              <!--<![endif]-->
              <!--[if gte IE 6]>-->
                <p>
                        Either scripts and active content are not permitted to run or Adobe Flash Player version
                        10.1.0 or greater is not installed.
                </p>
              <!--<![endif]-->
                  <a href="http://www.adobe.com/go/getflashplayer">
                      <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />
                  </a>
              <!--[if !IE]>-->
              </object>
              <!--<![endif]-->
          </object>
    </noscript>

</body>
</html>
