$(document).ready(function(){
	console.log('hello eFlight');

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

	if($('#pageType').val() == 'purchaseFlightView'){
		console.log('搜索');
		$('#search-btn').click(function(){
			loadData();
		})
	}

	if($('#pageType').val()=="publicView"){
	}

})

//购票入口搜索机票
function loadData(){
	var data = getData();
	console.log(data);
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/purchaseSearch',
		data:data,
		type:'GET',
		success:function(data){
			console.log(data);
		}
	})
}


//购票搜索页获取搜索参数
function getData(){
	var departure = $('#departure_arg').val();
	var arrival = $('#arrival_arg').val();
	var departDate = $('#departDate_arg').val();

	return {'departure':departure,'arrival':arrival,'departDate':departDate};
}


//购票搜索页模板
function purchaseListTemplate(data){
	var html = "";

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
				}
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