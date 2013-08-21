$(document).ready(function() {

  $(".delete_button").click(function(){
    var route = $(this).attr("data-route");
    var request = $.ajax({
      url: route,
      type: "POST",
      dataType: "json",
      data: {"_method":"delete"},
      success: function(msg){
        $(this).closest("tr").slideUp().remove();
      }
    });
  });

});