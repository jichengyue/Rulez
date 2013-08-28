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

  $(".log-buttons").change(function(){ 
    var c = new Array();
    if($("#log-fatal-button")[0].checked) {
      c.push("FATAL");
    }
    if($("#log-error-button")[0].checked) {
      c.push("ERROR");
    }
    if($("#log-warning-button")[0].checked) {
      c.push("WARNING");
    }
    if($("#log-info-button")[0].checked) {
      c.push("INFO");
    }
    if($("#log-debug-button")[0].checked) {
      c.push("DEBUG");
    }

    if(c.length) {
      var request = $.ajax({
        url: BASE_URL + "displaylog",
        type: "GET",
        data: {checkbox_actives: c},
        dataType: "json",
        success: function(msg) {
          $("#log-result").empty();
          $.each(msg,function(i){
            var itemcolor = "item-default";
            if(msg[i].match("FATAL")) {
              itemcolor = "item-fatal";
            }
            else if(msg[i].match("ERROR")) {
              itemcolor = "item-error";
            }
            else if(msg[i].match("WARNING")) {
              itemcolor = "item-warning";
            }
            else if(msg[i].match("INFO")) {
              itemcolor = "item-info";
            }
            $("#log-result").append($("<li>", {
              text: msg[i],
              class: "list-group-item "+itemcolor
            }));
          })
        }
      });
    }
    else {
      $("#log-result").empty();
    }

  });

  $(".log-buttons").click(function(){ 

  });

});
