$(document).ready(function() {

  $(".delete_button").click(function(){
    $this = $(this)
    var route = $this.attr("data-route");
    if(confirm("Are you sure?")){
      var request = $.ajax({
        url: route,
        type: "POST",
        dataType: "json",
        data: {"_method":"delete"},
        success: function(msg){
          $this.closest("tr").remove();
        }
      });
    }
  });

});