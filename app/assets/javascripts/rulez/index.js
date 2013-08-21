$(document).ready(function() {

  $("#doctor_button").click(function(){
    var request = $.ajax({
      url: BASE_URL + "doctor" ,
      type: "GET",
      dataType: "html"
    });
     
    request.done(function(msg) {
      $("#doctor_output").html( msg );
    });

  });

});