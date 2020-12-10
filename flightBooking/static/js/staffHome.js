var record = null;

$(document).ready(function(){

	getRecord();
	var height = $(window).height();
	var width = $(window).width();

	$('#view').selectmenu({
	    select: function() {
        if($(this).val() != '') {
            window.location.href = $(this).val();
        }
    }

	});


	$('#create').selectmenu({
	    select: function() {
        if($(this).val() != '') {
            window.location.href = $(this).val();
        }
    }

	});	

	$('.date-input').datepicker({
		dateFormat:"yy-mm-dd"
	}
		

	);

	$('.btn').button();

	$('.update-dialog').dialog({
		autoOpen:false,
		modal:true,
		height:height*0.3,
		width:width*0.3


	});

	$('.info-dialog').dialog({
		autoOpen:false,
		modal:true,
		height:height*0.6,
		width:width*0.3


	});	


	// $('.update').click(function(){
	// 	$('.update-dialog').dialog('open');

	// 	$('.status-select').selectmenu();
	// })

	// $('.info').click(function(){
	// 	$('.info-dialog').dialog("open");
	// })

	$('#status').selectmenu({
		  select: function( event, ui ) {
		  	console.log($(this).val());
		  	var selected = $(this).val();
		  	$('#select-status').val(selected);

		  }
		});

	$('.status-select').selectmenu({
		  select: function( event, ui ) {
		  	console.log($(this).val());
		  	var selected = $(this).val();
		  	$('#update-status').val(selected);

		  }		
	})



	$('#apply').click(function(){
		getRecord();
	})
})


function getRecord(){
	var startDate = $('#start-date').val();
	var endDate  = $('#end-date').val();
	var departure = $('#departure').val();
	var arrival = $('#arrival').val();
	var status = $('#select-status').val();
	var data = {'startDate':startDate,'endDate':endDate,'departure':departure,'arrival':arrival,'status':status};
	$('.view-container').LoadingOverlay("show");
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/staffViewFlights',
		data:data,
		success:function(response){
			console.log(response);
			record = response;
			$('.list-container').empty();
			for(var i=0;i<response.length;i++){
				var html = recordTemplate(response[i]);
				$('.list-container').append(html);
				
			}
			$('.btn').button();
			$('.view-container').LoadingOverlay("hide");
			var height = $(window).height();
			var width = $(window).width();

		
			$('.update-dialog').dialog({
				autoOpen:false,
				modal:true,
				height:height*0.3,
				width:width*0.3


			});

			$('.info-dialog').dialog({
				autoOpen:false,
				modal:true,
				height:height*0.6,
				width:width*0.3


			});	
		}

	})
}

function recordTemplate(data){
	var count = $('.flight-card').length;
	var depart_time = moment(data['departure_time']).format('YYYY MM DD HH:MM');
	var arrive_time = moment(data['arrival_time']).format('YYYY MM DD HH:MM');
	var status = flightStatusParser(data['status']);
	var html ='';
	html += '<div class="my-container flight-card"><form style="display:none;"><input id='+count+'type="text"></form>';
	html += '<div class="my-container card-column">';
	html += '<div class="my-container">'+data['airline_name']+'</div>';
	html += '<div class="my-container">'+data['flight_num']+'</div>';
	html += '</div><div class="my-container card-column">';
	html += '<div class="my-container strong-text">'+depart_time + '</div>';
	html += '<div class="my-container">'+ data['departure_airport'] +'&nbsp'+ data['departure_city']+ '</div>';
	html += '</div><div class="my-container card-column icon-column"><div class="my-container icon arrow"></div></div>';
	html += '<div class="my-container card-column">';
	html += '<div class="my-container strong-text">' + arrive_time + '</div>';
	html += '<div class="my-container">';
	html += data['arrival_airport']+'&nbsp'+data['arrival_city'];
	html += '</div></div>';
	html += '<div class="my-container card-column"><div class="my-container strong-text">'+status+'</div></div>';
	html += '<div class="my-container card-column button-column"><div class="my-container btn-container"><button class="btn update" onclick="openUpdate(this)" id='+count+'>update</button></div>';
	html += '<div class="my-container btn-container"><button class="btn info" onclick="openInfo(this)" id='+count+'>info</button></div>';
	html += '</div></div>';
	return html;
}
		
function flightStatusParser(status){
	if(status == '0'){
		return "未出发";
	}
	if(status == '1'){
		return "已出发";
	}
	if(status == '2'){
		return "已到达";

	}
	if(status = "3"){
		return "延误";
	}
	if(status == "4"){
		return "已取消";
	}
}
		
			
			
		


		
function openUpdate(th){
	$('.update-dialog').dialog("open");
	var index = $(th).attr('id');
	console.log(record[index]);
	$('#selected-flightNum').val(record[index]['flight_num']);
	$('#selected-airlineName').val(record[index]['airline_name']);
}

function openInfo(th){
	$('.info-dialog').dialog("open");
	var index = $(th).attr('id');
	console.log(record[index]);
	$('#selected-flightNum').val(record[index]['flight_num']);
	$('#selected-airlineName').val(record[index]['airline_name']);
	getPassengers();
}

function doUpdate(th){
	var flight_num = $('#selected-flightNum').val();
	var new_state = $('#update-status').val();
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/changeStatus',
		data:{'flight_number':flight_num,'new_status':new_state},
		success:function(data){
			console.log(data);
		}

	})
}

function getPassengers(){
	var flight_num = $('#selected-flightNum').val();

	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/getInfo',
		data:{'flight_number':flight_num},
		success:function(res){
			console.log(res);
			$('.passenger-container').empty();
			for(var i=0;i<res.length;i++){
				var html = renderPassenger(res[i]);
				$('.passenger-container').append(html);
			}
		}
	})
}

function renderPassenger(data){
	var html = "";
	html += '<div class="my-container passenger">';
	html += '<p>' + data['passenger_name'] + '</p>';
	html += '</div>';
	return html;
}