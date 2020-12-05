$(document).ready(function(){
	$('#back-to-login').button();

	$('#passport_expiration').datepicker();

	$('#date_of_birth').datepicker();

	$('#register-btn').button();

	var availAirlines = ['Shenzhen Airline', 'China Southern', 'China Eastern'];

	$('#airline_name').autocomplete({
		source:availAirlines
	});
})

function backToLogin(th){
	window.location.replace("http://localhost:5000/eFlight/login/customer")
}