
// Quick definitions
l = "left";
f = "forward";
r = "right";
b = "back";
h = "hard";
t = "fast";
s = "stop";


var Controls = {

left: false,
fwd: false,
right: false,
back: false,
hard: false,
fast: false,

getCommandStr: function() {

  retStr = "";

  // Add each of the active direction (chording)
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


  // If nothing is active, return to stopped
  if( retStr.length == 0 ) {
    retStr = s;
  }
  else {
    // Only add speed/turn modifiers when there is a non-stop action
    if( Controls.hard ) {
      retStr += h + " ";
    }
    if( Controls.fast ) {
      retStr += t + " ";
    }
  }

  // 
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
  case 17:
    return Controls.hard;
  case 16:
    return Controls.fast;
  default:
    return false;
  }
},

activateDeactivateKey: function(inKey) {
  // If a, A, left-arrow
  if( (inKey == 97 || inKey == 65 || inKey == 37) ) {
    Controls.left = !Controls.left;
  }
  // If w, W, up-arrow
  if( (inKey == 119 || inKey == 87 || inKey == 38) ) {
    Controls.fwd = !Controls.fwd;
  }
  // If d, D, right-arrow
  if( (inKey == 100 || inKey == 68 || inKey == 39) ) {
    Controls.right = !Controls.right;
  }
  // If s, S, down-arrow
  if( (inKey == 115 || inKey == 83 || inKey == 40) ) {
    Controls.back = !Controls.back;
  }
  // If CTRL
  if( inKey == 17 ) {
    Controls.hard = !Controls.hard;
  }
  // If SHIFT
  if( inKey == 16 ) {
    Controls.fast = !Controls.fast;
  }

  return;
},

}


$(document).ready( function() {
  rId = gup("robotId") ? gup("robotId") : 0;

  $('body').keydown( function(e) {
    if( !Controls.keyIsActive(e.which) ) {
      Controls.activateDeactivateKey(e.which);
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
      Controls.activateDeactivateKey(e.which);
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


