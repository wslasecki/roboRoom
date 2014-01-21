var Controls = {

getCommandName: function(inKey) {
  switch(inKey) {
  case 119:
  case 87:
    return "forward";
  case 97:
  case 65:
    return "left";
  case 100:
  case 68:
    return "right";
  case 115:
  case 83:
    return "back";
  default:
    return "stop";
  }
}

}


$(document).ready( function() {

  $('body').keypress( function(e) {
    cmd = Controls.getCommandName(e.which);
    console.log(e.which + " ==> " + cmd);

    rId = gup("robotId") ? gup("robotId") : 0;
    // Send the input to the command DB
    $.ajax({
      url: "sendInput.php",
      type: "POST",
      data: {robotId: rId, command: cmd},
      dataType: "text",
      success: function(d) {
        console.log("Successfully sent!")
      }
    });

  });
});
