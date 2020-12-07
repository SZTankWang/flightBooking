$(document).ready(function(){
	$('#search').click(function(){
		doSearch();
	})


})

function getSearchArgs(){
	var departure = $('#departure-city').val();
	var arrival = $('#arrival-city').val();
	var date = $('#departure-time').val();

	if(departure == '' || arrival == '' || date== ''){
		return -1
	}

	return {'departure':departure,
			'arrival':arrival,
			'departDate':date
			}

}

function doSearch(){
	var data = getSearchArgs();
	console.log(data);

	if(data == -1){
		$('.info-dialog').dialog({
			show:{
				effext:"Fade",
				duration:700
			}
		})
	}
	else{
		
		window.location.href='http://127.0.0.1:5000/eFlight/viewFlight?departure='+data['departure']+'&arrival='+data['arrival']+'&departDate='+data['departDate'];	
		

	}

}


