// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//= require jquery3
//= require jquery_ujs

document.addEventListener("turbolinks:load", function() {

  $('#management_select').change(function() {
    $('#management_form').submit();
  });

  $('#branch_select').change(function() {
    $('#branch_form').submit();
  });

  $('#check_invitable').change(function(e) {
    if($(this).is(':checked')){
      $('#pass_fields').hide();
    }else{
      $('#pass_fields').show();
    }
  });

  $('#policy_group_select').change(function() {
    var selectValue = $(this).val();

    jQuery.ajax({
      type: 'GET', 
      url: "/auth_m/policy_groups/load_policies",
      data: {policy_selected: selectValue}
    });
  });

});