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
	}

})

//购票入口搜索机票
function loadData(){
	var data = getData();

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
	type = searchType();
	if(type == 0){
		var data = flightNumSearch();
		data['type'] = 0;
		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/search',
			data:data,
			success:function(data){
				console.log(data);
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
	html += data['flightNum'];
	html += '</p></div></div><div class="my-container list-item-sub-container">';
	html += '<div class="my-container text-container"><p>';
	html += data['departureTime'];
	html += '</p></div>';
	html += '<div class="my-container text-container"><p>';
	html += data['departure'];
	html += '</p></div></div><div class="my-container list-item-sub-container">';
	html += '<div class="my-container text-container"><p>';
	html +=  data['arrivalTime'];
	html += '</p></div><div class="my-container text-container"><p>';
	html += data['arrival'];
	html += '</p></div></div><div class="my-container list-item-sub-container"><div class="my-container text-container"><p>';
	html += data['status'];
	html += '</p></div></div></div>';
	return html;


}