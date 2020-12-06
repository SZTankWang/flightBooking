$(document).ready(function(){
	$('#search').click(function(){
		doSearch();
	})


})

function getSearchArgs(){
	var departure = $('#departure-city').val();
	var arrival = $('#arrival-city').val();
	var date = $('#departure-time').val();
	return {'departure':departure,
			'arrival':arrival,
			'departDate':date
			}

}

function doSearch(){
	var data = getSearchArgs();
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/purchaseSearch',
		data:data,
		success:function(data){
			console.log(data);
		}
	})
}


