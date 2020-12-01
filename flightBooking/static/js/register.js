$(document).ready(function(){
	$('#passport_expiration').datepicker();

	$('#date_of_birth').datepicker();

	$('#register-btn').button();

	var availAirlines = ['Shenzhen Airline', 'China Southern', 'China Eastern'];

	$('#airline_name').autocomplete({
		source:availAirlines
	});
})