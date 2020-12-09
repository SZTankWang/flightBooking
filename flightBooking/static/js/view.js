$(document).ready(function(){
	var pageType = $('#viewType').val();
	if(pageType == 'customer'){

		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/viewFrequentCustomer',
			type:'GET',
			success:function(data){
				console.log(data);
				$('#top-customer').html(data['customer_email']);
				$('#top-ticket-count').html(data['number']);
			}
			});


	};

	if(pageType == 'bookingAgent'){

		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/viewBookingAgent',
			type:'GET',
			success:function(data){
				console.log(data);
				// $('#top-customer').html(data['customer_email']);
				// $('#top-ticket-count').html(data['number']);
			}
			});

	}


})
	