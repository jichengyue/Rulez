$(document).ready(function() {

  $(".delete_button").click(function(){
    var route = $(this).attr("data-route");
    var request = $.ajax({
      url: route,
      type: "DELETE",
      dataType: "html"
    });
    request.done(function(msg) {
      alert("sega!");
    });

  });

});