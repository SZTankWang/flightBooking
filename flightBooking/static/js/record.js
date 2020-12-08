$(document).ready(function(){
	//页面初始化 搜索
	search();

	$('#search-btn').button();

	$('#departureTime').datepicker();
	$('#arrivalTime').datepicker();

	var type = $('#pageType').val();
	var userName = $('#userName').val();

	var pagination = $('.pagination-wrapper');
	$('.pagination-wrapper').pagination({
		dataSource:function(done){
			var result = search();
			done(result['data']);

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

function search(pageNumber,pageSize){
	var purchase_id = $('#purchaseID').val();
	var departure_time = $('#departureTime').val();
	var arrival_time = $('#arrivalTime').val();
	var status = $('#status').val();
	var userType = $('#userType').val();
	var pageNumber = pageNumber;
	var pageSize = pageSize;
	var data = {'purchase_id':purchase_id,'departure_time':departure_time,'arrival_time':arrival_time,'status':status,'userType':userType};
	var result = null;
	$.ajax({
		url:'http://localhost:5000/eFlight/queryPurchaseRecord',
		data:data,
		success:function(data){
			result = data;
		}
	})
	return result;
}


function recordTemplate(data){
	var html ="";

	html += '<div class="my-container record-content list-item">';
	html += '<div class="my-container record-content list-row list-item-title">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['purchaseID']+'</p>';
	html += '</div>';
	html += '<div class="my-container list-text-wrapper">';
	html += '<p>'+['purchase_time']+'</p>';
	html += '</div>';
	html += '</div>';
	html += '<div class="my-container record-content list-row">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<h4>'+['departure_airport']+'</h4>';
	html += '</div>';
	html += '<div class="my-container icon-wrapper right-arrow">';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<h4>'+data['arrival_airport']+'</h4>';
	html += '</div>';					
	html += '</div>';
	html += '<div class="my-container record-content list-row">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>time</p>';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>>'+data['departure_time']+'</p>';
	html += '</div>';		
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['airline']+'</p>';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['flight_num']+'</p>';
	html += '</div></div>';
	html += '<div class="my-container record-content list-row">';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>passenger</p>';
	html += '</div>';
	html += '<div class="my-container text-wrapper list-text-wrapper">';
	html += '<p>'+data['passenger_name_list']+'</p>';
	html += '</div>';								
	html += '</div>';									
	html += '</div>';
	return html;
}