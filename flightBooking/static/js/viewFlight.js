var queryResult = null;

$(document).ready(function(){
	console.log('hello eFlight');

	//订票
	


	//公共信息搜索页 初始化搜索类型为航班号
	$('#search-type').val(0);

	$('#departure-time').datepicker();
	$('#search-btn').button();
	$('#filter-menu').menu();
	// $('.booking-btn').button();
	$('.radio').checkboxradio();

	$('.radio').change(function(){
		if (this.value == 1){
			$('#flight-num').css('display','none');
			$('#search-by-place-holder').css('display','block');
			$('#search-type').val("1")

		}else if (this.value ==0){
			$('#search-by-place-holder').css('display','none');
			$('#flight-num').css('display','block');
			$('#search-type').val(0);
		}

	})

	$('#search-btn').click(function(){
		searchFlight();
	})

	//预定机票点击按钮



	//购票搜索页 初始先请求
	if($('#pageType').val() == 'purchaseFlightView'){
		console.log('搜索');
		var departure = $('#departure_arg').val();
		var arrival = $('#arrival_arg').val();
		var departDate = $('#departDate_arg').val();

		//填写搜索框
		$('#departure').val(departure);
		$('#arrival').val(arrival);
		$("#departure-time").datepicker("setDate",departDate);
		loadData();
		$('#search-btn').click(function(){
			loadData();
		})
	}

	if($('#pageType').val()=="publicView"){
	}

})

//购票入口搜索机票
function loadData(){
	$(".main-info-wrapper").LoadingOverlay("show");
	if($('.place-holder')){
		$('.place-holder').remove();
		}
	$('.flight-card-container').empty();
	// $('.flight-card-container').empty();
	var data = getData();
	console.log(data);
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/purchaseSearch',
		data:data,
		type:'GET',
		success:function(data){
			// console.log(data);
			queryResult = data;
			console.log(queryResult);
			if(data.length >0){
				for(var i=0;i<data.length;i++){
					if(data[i]['status']==0){
						var html = purchaseListTemplate(data[i])
						$('.flight-card-container').append(html);
					}
				}				
			}else{

				var html = addPlaceHolder();
				$('#card-outer-container').append(html);
			}

			$(".main-info-wrapper").LoadingOverlay("hide");
		}
	})
}

function addPlaceHolder(){
	var html = '';
	html += '<div class="content-wrapper place-holder">';
	html += '<p>Less price, better experience</p>';
	html += '</div>';
	return html;
}

//购票搜索页获取搜索参数
function getData(){
	var departure = $('#departure').val();
	var arrival = $('#arrival').val();
	var departDate = $('#departure-time').val();

	return {'departure':departure,'arrival':arrival,'departDate':departDate};
}


//购票搜索页模板
function purchaseListTemplate(data){
	var count  = $('.flight-card').length;
	var html = "";
	html += '<div class="flight-card-wrapper"><form class="flight-info-form" style="display:none;"><input class="flightNum" name="flightNum" value='+data['flight_num']+'><input class="airline" name="airline_name" value= '+data['airline_name']+'></form><div class="flight-card">';
	html += '<div class="card-flight-info">';
	html += '<div>' + data['airline_name'] +data['flight_num']+ '</div>';
	html += "</div>";
	html += '<div class="card-flight-info card-flight-depart-info">';
	html += '<div class=" flight-depart-time strong-container"><strong>';
	html += moment(data['departure_time']).format("HH:MM");
	html += '</strong></div>';
	html += '<div class=" flight-depart-airport airport">' + data['departure_city'] + ' ';
	html += data['departure_airport'];
	html += '</div></div><div class="card-flight-info card-flight-arrival-info">';
	html += '<div class="card-flight-arrive-time strong-container"><strong>';
	html += moment(data['arrival_time']).format("HH:MM");
	html += '</strong></div><div class="card-flight-arrive-airport airport">'+data['arrival_city'] + ' ';
	html += data['arrival_airport'];
	html += '</div></div><div class=" card-flight-info card-flight-price-info">';
	html += data['price'];
	html += '</div><div class="card-flight-info card-flight-book"><button class="ui-button ui-widget ui-corner-all book-btn" onclick="goConfirmOrder(this)"';  
	html += `id = `+count+`>`;
	html += 'Book</button></div></div></div>';
	return html



}

function goConfirmOrder(th){
	var i = $(th).attr('id');
	console.log($(th).attr('id'));
	console.log(queryResult[i]);
	var flight_num = queryResult[i]['flight_num']
	var airline_name = queryResult[i]['airline_name']
	window.location.href = 'http://127.0.0.1:5000/eFlight/confirmOrder?flight_num='+flight_num+'&airline_name='+airline_name;

}




// 公共搜索入口
//搜索先决条件：按照什么搜索

function searchFlight(){
	var type = $('#search-type').val();
	doSearch();

}

function searchType(){
	return $('#search-type').val();
}

function doSearch(){
	$('.outer-wrapper').LoadingOverlay("show");
	type = searchType();
	if(type == 0){
		var data = flightNumSearch();
		data['type'] = 0;

		var date = moment(data['departureDate']).format("MMMM DD dddd");
		$('#departure-date-info').html(date);

		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/search',
			data:data,
			success:function(data){
				console.log(data);
				$('.search-result-list').empty();
				$('#search-result-count').html('result count '+data.length);
				for(var i=0;i<data.length;i++){
					var html = listItemTemplate(data[i]);
					$('.search-result-list').append(html);
				};
				$('.outer-wrapper').LoadingOverlay("hide");
	
			}
		})
	}else if(type == 1){
		var data = placeSearch();
		data['type'] = 1;
		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/search',
			data:data,
			success:function(data){

				console.log(data);
				$('.list-item').empty();
				for(var i=0;i<data.length;i++){
					var html = listItemTemplate(data[i]);
					$('.search-result-list').append(html);
				};

				$('.outer-wrapper').LoadingOverlay("hide");

			}
		})

	}
}

function flightNumSearch(){
		var flightNum = $('#flight-num').val();
		var date = $('#departure-time').datepicker("getDate");
		date = $.datepicker.formatDate( "yy-mm-dd", date);
		return {'flightNum':flightNum,'departureDate':date};
}

function placeSearch(){
	var departure = $('#departure').val();
	var arrival = $('#arrival').val();
	var date = $('#departure-time').datepicker("getDate");
	date = $.datepicker.formatDate( "yy-mm-dd", date);

	return {'departure':departure,'arrival':arrival,'departureDate':date};


}

function listItemTemplate(data){
	var html = '';
	html += '<div class="my-container serach-info-row list-item">';
	html += '<div class="my-container list-item-sub-container">';
	html += '<div class="my-container text-container"><p>';
	html += data['flight_num'];
	html += '</p></div></div><div class="my-container list-item-sub-container">';
	html += '<div class="my-container text-container"><h4>';
	html += moment(data['departure_time']).format('h:mm');
	html += '</h4></div>';
	html += '<div class="my-container text-container"><p>';
	html += data['departure_airport'];
	html += '</p></div></div><div class="my-container list-item-sub-container">';
	html += '<div class="my-container text-container"><h4>';
	html +=  moment(data['arrival_time']).format('h:mm');;
	html += '</h4></div><div class="my-container text-container"><p>';
	html += data['arrival_airport']
	html += '</p></div></div><div class="my-container list-item-sub-container"><div class="my-container text-container"><p>';
	html += flightStatusParser(data['status']);
	html += '</p></div></div></div>';
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