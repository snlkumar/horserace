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
	// $("#client_trail_duration").attr("disabled",true);
	$("#alter_bank").hide();
	$("#respond_to").hide();	
	$("#transaction_deposit").hide();	
    $("#transaction_withdraw").hide();
    $("#deposit_form").hide();
    $("#withdraw_bank").hide();
     $(".deposit_error").hide();
    
});


// $(document).on("change","#client_is_this_trial",function(){
// 		
	// attr=$("#client_trail_duration").attr("disabled");	
	// alert(attr)
	// if (attr=="disabled"){
	// $("#client_trail_duration").attr("disabled",false);
	// alert("kdjfkfjkj")
	// }else{
		// $("#client_trail_duration").attr("disabled",true);
	// }
// });
		
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

$(document).on("change","#client_user_attributes_password",function(){
	var password=$(this).val();
	$("#client_custom_password").val(password);
});

$(document).on("click","#withdraw",function(){
			$("#transaction_deposit").hide();	
			$("#withdraw_bank").show();
			$("#deposit_form").hide();
			$("#transaction_withdraw").show();
	});
$(document).on("click","#deposit",function(){
	    $("#submit_fund").attr("disabled", true);
		$("#transaction_deposit").show();
		$("#withdraw_bank").hide();	
		$("#transaction_withdraw").hide();
		$("#deposit_form").show();
});

$(document).on("focusout","#deposit_phone",function(){
	var phone=$(this).val();	
	if (phone.length==0){		
		$('ul.alert-error li').html("Please enter mobile");
		$(".deposit_error").show();
	}
	
});
$(document).on("focusout","#deposit_messages",function(){
	var phone=$(this).val();	
	if (phone.length==0){		
		$('ul.alert-error li').html("Please enter message");
		$(".deposit_error").show();
	}else{
		$("#submit_fund").attr("disabled", false);
	}
	
});
// $(document).ready(function(){		
     // $(".edit_horse_no").each(function(){
      // var horse_place=$(this).val();
      // var race = $(this).attr("race");
      // var race_name = $(this).attr("race_name");
	    // if(horse_place.length==0){
	    	// var i = ("#race_"+race);	    	
	       // $(i).parent("p").attr("class","class_changed");	
	       // $('ul.alert-error li').html("Please place the horse for"+race_name+" before change the status");
		   // $(".deposit_error").show();
	    // }     	
     // });
// });
// 
$(document).on("click","#search_client",function(){
		var input=$("#seach_client").val();	
			$.get("/users/search_clients/"+input,function(data){
				$("#user_view_client").empty();
				$("#user_view_client").html(data);
			});
		});
