$(document).ready(function() {

  var context_select = $('#rule_context_id')[0];

  if(context_select){
    $(context_select).change(function(){
      var context_id = $('#rule_context_id')[0].value;
      var request = $.ajax({
        url: BASE_URL + "/contexts/" + context_id + "/variables" ,
        type: "GET",
        dataType: "html"
      });
       
      request.done(function(msg) {
        $("#available_variables").html( msg );
      });

    });

    if(context_select.value){
      $(context_select).change();
    }
  }
  
});