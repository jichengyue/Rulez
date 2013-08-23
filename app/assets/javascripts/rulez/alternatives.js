$(document).ready(function() {

  var request = $.ajax({
    url: BASE_URL + "/contexts/" + context_id + "/variables" ,
    type: "GET",
    dataType: "html"
  });
   
  request.done(function(msg) {
    $("#available_variables").html( msg );
  });

});