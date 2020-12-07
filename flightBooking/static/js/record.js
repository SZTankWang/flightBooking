$(document).ready(function(){
	$('#search-btn').button();

	$('#departureTime').datepicker();
	$('#arrivalTime').datepicker();

	var type = $('#pageType').val();
	var userName = $('userName').val();


	$('.pagination-wrapper').pagination({
		dataSource:'http://localhost:5000/eFlight/record'+type,
		ajax:{data:{userName: userName}},
		pageSize:5,
		totalNumberLocator:'total'
})

})