$(document).ready(function(){
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/viewTopCustomer',
		type:'GET',
		success:function(data){
			console.log(data);
		}
		});

})
	