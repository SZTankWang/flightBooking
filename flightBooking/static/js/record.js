
$(document).ready(function(){
	//页面初始化 搜索
	// search();

	$('#search-btn').button();

	$('#departureTime').datepicker();
	$('#arrivalTime').datepicker();

	var type = $('#pageType').val();
	var userName = $('#userName').val();

	var pagination = $('.pagination-wrapper');
	$('.pagination-wrapper').pagination({
		dataSource:function(done){
			search(1,5,done);

		},
		ajax:{data:{userName: userName}},
		pageSize:5,
		totalNumberLocator:function(response){
			return response['total_number'];
		},
		afterPageOnClick:function(){
			//获取当前页

			var currPage = pagination.pagination("getSelectedPageNum");
			$('#pageNumber').val(currPage);
			var pageSize = $('#pageSize').val();
			search(currPage,pageSize);
		},
		callback:function(data,pagination){
			$('.record-list-container').empty();
			for(var i =0;i<data.length;i++){
				var html = recordTemplate(data[i]);
				$('.record-list-container').append(html);
			}
		}

})

})

function search(pageNumber,pageSize,callback){
	var purchase_id = $('#purchaseID').val();
	var departure_time = $('#departureTime').val();
	if(departure_time != ''){
		departure_time = moment(departure_time).format('YYYY-MM-DD');
	}
	var arrival_time = $('#arrivalTime').val();
	if(arrival_time != ''){
		arrival_time = moment(arrival_time).format('YYYY-MM-DD');
	}
	var status = $('#status').val();
	var userType = $('#userType').val();
	var pageNumber = pageNumber;
	var pageSize = pageSize;
	var data = {'purchase_id':purchase_id,'departure_time':departure_time,'arrival_time':arrival_time,'status':status,'userType':userType};

	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/queryPurchaseRecord',
		data:data,
		success:function(response){
			callback(response);
		}
	})
	
}


function recordTemplate(data){
	var html ="";
	var purchase_date = moment(data['purchase_date']).format('YYYY MM DD');
	var departure_time = moment(data['departure_time']).format('YYYY MM DD HH:MM');

	html += '<div class="my-container record-content list-item">';
	html += '<div class="my-container record-content list-row list-item-title">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>purchase ID:&nbsp'+data['purchase_id']+'</p>';
	html += '</div>';
	html += '<div class="my-container list-text-wrapper">';
	html += '<p>'+purchase_date+'</p>';
	html += '</div>';
	html += '</div>';
	html += '<div class="my-container record-content list-row">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<h4>'+data['departure_city']+'</h4>';
	html += '</div>';
	html += '<div class="my-container icon-wrapper right-arrow">';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<h4>'+data['arrival_city']+'</h4>';
	html += '</div>';					
	html += '</div>';
	html += '<div class="my-container record-content list-row">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>time</p>';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+departure_time+'</p>';
	html += '</div>';		
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['airline_name']+'</p>';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['flight_num']+'</p>';
	html += '</div></div>';
	html += '<div class="my-container record-content list-row">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>passenger</p>';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['passenger_list']+'</p>';
	html += '</div>';								
	html += '</div>';									
	html += '</div>';
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