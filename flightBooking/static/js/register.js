$(document).ready(function(){
	$('#back-to-login').button();

	$('#passport_expiration').datepicker({
		dateFormat: "yy-mm-dd"
	});

	$('#date_of_birth').datepicker({
		dateFormat: "yy-mm-dd"
	});

	$('#register-btn').button();

	var availAirlines = ['Shenzhen Airline', 'China Southern', 'China Eastern'];

	$('#airline_name').autocomplete({
		source:availAirlines
	});

	$('#register-btn').click(function(){
		loadFormToData();
	})
})

function backToLogin(th){
	window.location.replace("http://127.0.0.1:5000/eFlight/login/customer")
}

function loadFormToData(){
	var form= document.getElementById('register-form');
	var data = new FormData(form);
	return data;	
}

function register(th){
	var userType = $('#type').val();
	var data = loadFormToData();
	data.append('type',userType);
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/doRegister',
		type:'POST',
		data:data,
		contentType:false,
		processData:false,
		success:function(res){
			console.log(res);
			if(res['code']==0){
				window.location.href = 'http://127.0.0.1:5000/eFlight/login/'+userType;
			}
			else if(res['code']==-1){
				window.location.href = 'http://127.0.0.1:5000/eFlight/home';
			}
		}
	})
}