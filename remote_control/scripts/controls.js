
// Quick definitions
l = "left";
f = "forward";
r = "right";
b = "back";
h = "hard";
s = "stop";


var Controls = {

left: false,
fwd: false,
right: false,
back: false,
hard: false,

getCommandStr: function() {

  retStr = "";

  if( Controls.left ) {
    retStr += l + " ";
  }
  if( Controls.fwd ) {
    retStr += f + " ";
  }
  if( Controls.right ) {
    retStr += r + " ";
  }
  if( Controls.back ) {
    retStr += b + " ";
  }
  if( Controls.hard ) {
    retStr += h + " ";
  }


  if( retStr.length == 0 ) {
    retStr = s;
  }

  return retStr.trim();
},

keyIsActive: function(inKey) {
  switch(inKey) {
  case 97:
  case 65:
  case 37:
    return Controls.left;
  case 119:
  case 87:
  case 38:
    return Controls.fwd;
  case 100:
  case 68:
  case 39:
    return Controls.right;
  case 115:
  case 83:
  case 40:
    return Controls.back;
  case 16:
    return Controls.hard;
  default:
    return false;
  }
},

activateKey: function(inKey) {
  if( !Controls.left && (inKey == 97 || inKey == 65 || inKey == 37) ) {
    Controls.left = true;
  }
  if( !Controls.fwd && (inKey == 119 || inKey == 87 || inKey == 38) ) {
    Controls.fwd = true;
  }
  if( !Controls.right && (inKey == 100 || inKey == 68 || inKey == 39) ) {
    Controls.right = true;
  }
  if( !Controls.back && (inKey == 115 || inKey == 83 || inKey == 40) ) {
    Controls.back = true;
  }
  if( !Controls.hard && inKey == 16 ) {
    Controls.hard = true;
  }

  return;
},

deactivateKey: function(inKey) {
  if( Controls.left && (inKey == 97 || inKey == 65 || inKey == 37) ) {
    Controls.left = false;
  }
  if( Controls.fwd && (inKey == 119 || inKey == 87 || inKey == 38) ) {
    Controls.fwd = false;
  }
  if( Controls.right && (inKey == 100 || inKey == 68 || inKey == 39) ) {
    Controls.right = false;
  }
  if( Controls.back && (inKey == 115 || inKey == 83 || inKey == 40) ) {
    Controls.back = false;
  }
  if( Controls.hard && inKey == 16 ) {
    Controls.hard = false;
  }

  return;
},

}


$(document).ready( function() {
  rId = gup("robotId") ? gup("robotId") : 0;

  $('body').keydown( function(e) {
    if( !Controls.keyIsActive(e.which) ) {
      Controls.activateKey(e.which);
      cmd = Controls.getCommandStr();

      // Send the input to the command DB
      $.ajax({
        url: "sendInput.php",
        type: "POST",
        data: {robotId: rId, command: cmd},
        dataType: "text",
        success: function(d) {
          console.log("Key-down successfully sent! (" + cmd + ")");
        }
      });
    }

  });

  $('body').keyup( function(e) {
    if( Controls.keyIsActive(e.which) ) {
      Controls.deactivateKey(e.which);
      cmd = Controls.getCommandStr(e.which);

      // Send the input to the command DB
      $.ajax({
        url: "sendInput.php",
        type: "POST",
        data: {robotId: rId, command: cmd},
        dataType: "text",
        success: function(d) {
          console.log("Key-up successfully sent! (" + cmd + ")");
        }
      });
    }
  });

});


