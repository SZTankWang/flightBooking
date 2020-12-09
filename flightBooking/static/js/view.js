$(document).ready(function(){
	var pageType = $('#viewType').val();
	console.log(pageType);
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
				var month_ticket = data['month_ticket_result'];
				var year_ticket = data['year_ticket_result'];
				var commission_result = data['year_commission_result'];
				$('.month-result-container').empty();
				$('.year-result-container').empty();
				$('.commission-result-container').empty();
				for(var i=0;i<month_ticket.length;i++){
					var html = agentMonthTemplate(month_ticket[i]);
					$('.month-result-container').append(html);
				}

				for(var i=0;i<commission_result.length;i++){
					var html = agentCommissionTemplate(commission_result[i]);
					$('.commission-result-container').append(html);
				}				

				for(var i=0;i<year_ticket.length;i++){
					var html = agentMonthTemplate(year_ticket[i]);
					$('.year-result-container').append(html);
				}	



			}
			});

	}

	if(pageType == 'report'){
		console.log('hi');
		$('.btn').button();

		$('.left-search').click(function(){
			var startDate = $('#leftStartDate').val();
			var endDate = $('#leftEndDate').val();


			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/viewDateReport',
				data:{'startDate':startDate,'endDate':endDate},
				success:function(data){
					console.log(data);
				}

			})


		})

		}

	


})
function agentMonthTemplate(data){
	var html ='';
	html += '<div class="my-container agent-container">';
	html += '<p>'+ data['booking_agent_id'] + '</p>&nbsp&nbsp';
	html += '<p>sold </p>&nbsp';
	html += '<p>' + data['count(ticket_id)'] + '</p>&nbsp';
	html += '<p>ticket(s)</p>';
	return html;
}


function agentCommissionTemplate(data){
	var html ='';
	html += '<div class="my-container agent-container">';
	html += '<p>'+ data['booking_agent_id'] + '</p>&nbsp&nbsp';
	html += '<p>sold price of </p>&nbsp';
	html += '<p>' + data['sum(price)'] + '</p>&nbsp';
	// html += '<p></p>';
	return html;
}


