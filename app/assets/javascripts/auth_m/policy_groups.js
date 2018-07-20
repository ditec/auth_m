// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//= require jquery3
//= require jquery_ujs

document.addEventListener("turbolinks:load", function() {

  $('#policy_groups').change(function() {
    var selectValue = $(this).val();
    if(selectValue == "Customize"){
      $('#policies #policy_group_not_customized').remove();
      $('#customized_policies').show();
    }else{
      $('#customized_policies').hide();
      jQuery.ajax({
        type: 'POST', 
        url: '/auth_m/load_policies',
        data: {policy_group_selector: selectValue}
      });
    }
  });

  $('.roles').change(function(e) { 
    if ($('input[id=role1]:checked').length > 0) {
      $('#div_policy_groups').show();
    }else{
      $('#div_policy_groups').hide();
    }
  });

});