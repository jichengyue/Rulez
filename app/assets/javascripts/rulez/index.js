$(document).ready(function() {

  $("#doctor_button").click(function(){
    var request = $.ajax({
      url: BASE_URL + "doctor",
      type: "GET",
      dataType: "html"
    });
     
    request.done(function(msg) {
      $("#doctor_output").html( msg );
    });

  });

  $("#log-clear-button").click(function(){
    var request = $.ajax({
      url: BASE_URL + "clearlogfile",
      type: "GET",
      dataType: "json",
      success: function(msg) {
        $("#log_result").empty();
      }
    });
  });

  // $("#log-selection-button").click(function(){
  //   if($(this).text().indexOf("Select All") >= 0){
  //     $(this).html("Deselect All");
  //   }
  //   else {
  //     $(this).html("Select All");
  //   }
  //   $(".label-log-button").click();
  //   if(
  //     !$("#log_fatal_button")[0].checked &&
  //     !$("#log_error_button")[0].checked &&
  //     !$("#log_warning_button")[0].checked &&
  //     !$("#log_info_button")[0].checked &&
  //     !$("#log_debug_button")[0].checked){
  //       $("#log_result").empty();
  //     }
  // });

  $(".log-buttons").change(function(){
    compute_log_display();
  });

  $("#log-update-button").click(function(){
    compute_log_display();
  });

  $(".log-danger").click(function(){
    if($(this).hasClass("btn-default")) {
      $(this).removeClass("btn-default");
      $(this).addClass("btn-danger");
    }
    else {
      $(this).removeClass("btn-danger");
      $(this).addClass("btn-default");
    }
  });

  $(".log-warning").click(function(){
    if($(this).hasClass("btn-default")) {
      $(this).removeClass("btn-default");
      $(this).addClass("btn-warning");
    }
    else {
      $(this).removeClass("btn-warning");
      $(this).addClass("btn-default");
    }
  });

  $(".log-info").click(function(){
    if($(this).hasClass("btn-default")) {
      $(this).removeClass("btn-default");
      $(this).addClass("btn-info");
    }
    else {
      $(this).removeClass("btn-info");
      $(this).addClass("btn-default");
    }
  });

});

function compute_log_display() {
  var c = new Array();
  if($("#log_fatal_button")[0].checked) {
    c.push("FATAL");
  }
  if($("#log_error_button")[0].checked) {
    c.push("ERROR");
  }
  if($("#log_warning_button")[0].checked) {
    c.push("WARNING");
  }
  if($("#log_info_button")[0].checked) {
    c.push("INFO");
  }
  if($("#log_debug_button")[0].checked) {
    c.push("DEBUG");
  }

  var nr = $("#log_number_lines")[0].value;

  if(c.length) {
    var request = $.ajax({
      url: BASE_URL + "displaylog",
      type: "GET",
      data: {checkbox_actives: c, n_rows: nr},
      dataType: "json",
      success: function(msg) {
        $("#log_result").empty();
        $.each(msg.reverse(),function(i){
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
          $("#log_result").append($("<li>", {
            text: msg[i],
            class: "list-group-item "+itemcolor
          }));
        })
      }
    });
  }
  else {
    $("#log_result").empty();
  }
}