// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//

document.addEventListener("turbolinks:load", function() {

  $('#management_select').change(function() {
    $('#management_form').submit();
  });

  $('#branch_select').change(function() {
    $('#branch_form').submit();
  });

  $('#check_invitable').change(function(e) {
    if($(this).is(':checked')){
      $('#pass').prop('required',false);
      $('#pass_confirmation').prop('required',false);
      $('#pass_fields').hide();
    }else{
      $('#pass').prop('required',true);
      $('#pass_confirmation').prop('required',true);
      $('#pass_fields').show();
    }
  });

  $('#policy_group_select').change(function() {
    var selectValue = $(this).val();

    $.ajax({
      type: 'GET', 
      url: "/auth_m/policy_groups/load_policies",
      data: {policy_selected: selectValue},
      dataType: "script"
    });
  });

  $("#select_all").click(function() {
    $("input[type=checkbox]").prop("checked", $(this).prop("checked"));
  });

  $("input[type=checkbox]").click(function() {
    if (!$(this).prop("checked")) {
      $("#select_all").prop("checked", false);
    }
  });

});