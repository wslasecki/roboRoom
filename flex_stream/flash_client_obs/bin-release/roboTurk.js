var roboTurk = {
  payment: 0,
  
  epochPay: function(amount){
    roboTurk.payment += amount; // this is just a reported amount, changing it won't net anymore more $
    roboTurk.displayPay();
  },
  
  displayPay: function(){
    $('#payment').text('$' + roboTurk.payment.toFixed(2));
  },
  
  disconnect: function(){
    $('#form').submit();
  }
};