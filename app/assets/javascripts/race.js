$(document).on("click","#status",function(){
	 $.fn.editable.defaults.mode = 'inline';
	var token= $('meta[name="csrf-token"]').attr('content');
	var race=$(this).attr("race");
	var data={
		'id' : race,
		"authenticity_token": token
	};
  $(this).editable({
        type: 'select',
        title: 'Select status',
        placement: 'right',
        value: 2,
        source: [
            {value: 'win', text: 'Win'},
            {value: 'lost', text: 'Lost'}
            ],
         params: data,   
        
        //uncomment these lines to send data on server
        pk: 1,
        url: '/races/update_status?',
        success: function(response) {
        $("#update_status").empty();
        $("#update_status").html(response);
        }
});	
});







$(document).ready(function(){
	$("#dialog-form").hide();
	$('input:radio[name=bank_details][value=current]').attr('checked', true);
	$("#withdraw_bank_detail_id").val("");
	$("#user_trail_duration").attr("disabled",true);
	$("#alter_bank").hide();
	$("#respond_to").hide();	
});


$(document).on("change","#user_is_this_trial",function(){
	attr=$("#user_trail_duration").attr("disabled");
	
	if (attr=="disabled"){
	$("#user_trail_duration").attr("disabled",false);
	}else{
		$("#user_trail_duration").attr("disabled",true);
	}
});
		
$(document).on("click","#create-user",function(){
		var user_id=$(this).attr('user_id');
		$( "#dialog-form" ).dialog({
            autoOpen: true,
			height: 300,
			width: 350,
			modal: true,
			buttons: [{
				id: "confirm",
				text: "confirm",
				type: "submit",
				click: function() {
					var user_balance=$("#client_balance").val();
					var balance_password=$("#balance_password").val();
					if (balance_password){
					   $.ajax({
			          	type: "GET", 
			          	url: "/confirm_password",
			          	data: {
			          		'password': balance_password,
			          		'id': user_id
			          	}, 
			            dataType: "json",
			            success: function(data){
			            	if (data.html != "You are not a valid user to update balance"){
			                $(".ui-dialog-buttonpane button:contains('confirm') span").text("Update");
			                $( "#dialog-form" ).empty();
			            	$( "#dialog-form" ).html(data.html);
			                }else{
			            	$(".user_error").empty();
			            	$(".user_error").html(data.html);
			            }}
			          });
			         }else if(user_balance){
			         	$("#change_balance_form").submit();
			         }
					
					}},
					{
				   id: "cancel",
					  text: "Cancel",
					  click: function(){
					 $( this ).dialog( "close" );
				}}]
				 
	   });
	});
	
	
		$(document).on("click","#alternate",function(){
			$("#current_bank").hide();	
			$("#alter_bank").show();
			$("#withdraw_bank_detail_id").val("");
			$(this).attr('checked', true);
		});
		
		$(document).on("click","#current",function(){
			$("#alter_bank").hide();	
			$("#current_bank").show();
			$(this).attr('checked', true);
		});
	

$(document).on("change","#bank_id",function(){
	$("#transaction_bank_detail_id").val($(this).val());
});
$(document).on("change","#respond_select",function(){
	var selected=$(this).val();
	if (selected=="Other"){
		$("#client_respond_via").empty();
		$("#respond_to").show();
	}else{
		$("#respond_to").hide();
		$("#client_respond_via").empty();
		$("#client_respond_via").val(selected);
	}
	
	
});

$(document).on("change","#user_password",function(){
	var password=$(this).val();
	$("#user_custom_password").val(password);
});
