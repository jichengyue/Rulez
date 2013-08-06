$(document).ready(function() {

  var context_select = $('#rule_context_id')[0];

  $(context_select).change(function(){
    var context_id = $('#rule_context_id')[0].value;
    var request = $.ajax({
      url: BASE_URL + "/contexts/" + context_id + "/symbols" ,
      type: "GET",
      dataType: "html"
    });
     
    request.done(function(msg) {
      $("#available_symbols").html( msg );
    });

  });


  $('#methods_select').change(function(){
    $('#rule_rule').val( $('#rule_rule').val() + $(this).val() );
    $(this).val('').trigger('liszt:updated');
  });

  if(context_select.value){
    $(context_select).change();
  }

});