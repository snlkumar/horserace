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
					var user_balance=$("#user_balance").val();
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
			            	if (data.html != "You are not a valid user for update balance"){
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
	
	
		$(document).on("click",".left_link",function(){
			$(this).attr("class","active");
		});
	


