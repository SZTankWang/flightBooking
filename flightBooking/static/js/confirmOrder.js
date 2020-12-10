$(document).ready(function(){

	var departure_time_arg = $('#departure_time_arg').val();
	var arrival_time_arg = $('#arrival_time_arg').val();

	departure_time = moment(departure_time_arg).format("HH:MM");
	arrival_time = moment(arrival_time_arg).format("HH:MM");
	var weekday = moment(departure_time_arg).format('dddd');
	var date = moment(departure_time_arg).format('MM DD');

	var price = $('#price_arg').val();
	
	$('#date').html(date);
	$('#weekday').html(weekday);
	$('#arrival_time').html(arrival_time);
	$('#add-info').button();
	$('#confirm-btn').button();

	$('#add-info').click(function(){
		var newCount = $('.passenger-info-box').length+1;
		if(newCount <= 5){
			var newTotalPrice = price * newCount;
			$('#show-price').html(newTotalPrice);

			$('.passenger-info-container').append('<div class="passenger-info-box"><div class="passenger-info-sub-box info-input-field"><!-- 乘客姓名 --><div class="input-group input-group-sm passenger-name-input"><div class="input-group-prepend"><span class="input-group-text" id="basic-addon1"><svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-person-plus"fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M8 5a2 2 0 1 1-4 0 2 2 0 0 1 4 0zM6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm6 5c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10zM13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/></svg></span></div><input type="text" class="form-control eFlight-input name-input" placeholder="passenger name" aria-describedby="basic-addon1"></div><!-- 证件ID	 --><div class="input-group input-group-sm passenger-input"><div class="input-group-prepend"><span class="input-group-text" id="basic-addon1"><svg t="1605697192831" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2989" width="1rem" height="1rem"><path d="M21.333333 192c0-23.466667 19.2-42.666667 42.666667-42.666667h896c23.466667 0 42.666667 19.2 42.666667 42.666667v640c0 23.466667-19.2 42.666667-42.666667 42.666667H64c-23.466667 0-42.666667-19.2-42.666667-42.666667V192z m85.333334 597.333333h810.666666V234.666667H106.666667v554.666666z" fill="#707070" p-id="2990"></path><path d="M554.666667 469.333333h128c23.466667 0 42.666667-19.2 42.666666-42.666666s-19.2-42.666667-42.666666-42.666667h-128c-23.466667 0-42.666667 19.2-42.666667 42.666667s19.2 42.666667 42.666667 42.666666M768 554.666667H554.666667c-23.466667 0-42.666667 19.2-42.666667 42.666666s19.2 42.666667 42.666667 42.666667h213.333333c23.466667 0 42.666667-19.2 42.666667-42.666667s-19.2-42.666667-42.666667-42.666666M384 448c0-36.266667-27.733333-64-64-64s-64 27.733333-64 64 27.733333 64 64 64 64-27.733333 64-64M320 512c-59.733333 0-106.666667 40.533333-106.666667 89.6 0 49.066667 213.333333 49.066667 213.333334 0S379.733333 512 320 512" fill="#707070" p-id="2991"></path></svg></span></div><input type="text" class="form-control eFlight-input id-input" placeholder="passenger ID" aria-describedby="basic-addon1"></div><!-- 电话	 --><div class="input-group input-group-sm passenger-input"><div class="input-group-prepend"><span class="input-group-text" id="basic-addon1"><svg t="1605697236732" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3925" width="1rem" height="1rem"><path d="M622.37061 711.669332l28.308771-17.775275a277.162617 277.162617 0 0 1 29.625458-15.800244c65.834351-29.625458 121.135205-8.558466 197.503052 79.001221a138.91048 138.91048 0 0 1 42.133984 145.493915A180.386121 180.386121 0 0 1 830.407158 987.515261l-36.208893 21.066992c-106.651648 65.834351-350.897089-84.926312-526.674806-342.338623S45.661697 131.668701 153.630033 65.834351L168.11359 53.984168l15.1419-9.875153a178.411091 178.411091 0 0 1 131.668702-42.133984 157.344098 157.344098 0 0 1 105.993305 93.484778c65.834351 117.843488 48.71742 173.802686-31.600489 225.153479L359.033207 337.730219c-19.750305 12.508527 13.825214 94.143122 91.509748 208.694892S597.353557 724.177858 622.37061 711.669332z" p-id="3926" fill="#707070"></path></svg></span> </div><input type="text" class="form-control eFlight-input phone-input" placeholder="passenger phone" aria-describedby="basic-addon1"></div></div><div class="passenger-info-sub-box eflight-title"><a class="deleteUser" id='+newCount+' href = "#" onclick="deleteUser(this)" ><i>x</i>删除</a><h3 style="color:#f2f2f2">eFlight</h3></div></div>');
		}
	})

	$('#confirm-btn').click(function(){
		purchase();
	})
	
	// $('.deleteUser').click(function(){
	// 	$(this).parent('.parent-info-box').remove();
	// })

})

function deleteUser(th){
	var price = $("#price_arg").val();
	var prev_price = $('.passenger-info-box').length * price;
	var id = th.id;
	console.log(id);
	$(th).parents('.passenger-info-box').remove();
	$('#show-price').html(prev_price-price);
	// $('.passenger-info-box').each(function(index){
	// 	if(index+1 == id){
	// 		console.log(index);
	// 		$('.passenger-info-box')[index].remove();
	// 	}
	// })
}

function purchase(){
	var data = getPassengerData();
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/purchaseTicket',
		data:data,
		success:function(rsp){
			console.log(rsp);
			if(rsp['code']==0){
				var height = $(window).height();
				var width = $(window).width();
				$('.success').dialog({
					width:width*0.5,
					height:height*0.4,
					open:function(event,ui){
						setTimeout(function(){
							window.location.href = 'http://127.0.0.1:5000/eFlight/record/purchaseRecord';
						},1500);
					}

				});
			}else if(rsp['code']== -1){
				var height = $(window).height();
				var width = $(window).width();
				$('.failure').dialog({
					width:width*0.5,
					height:height*0.4,
					open:function(event,ui){
						setTimeout(function(){
							window.location.href = 'http://127.0.0.1:5000/eFlight/home';
						},1500);
					}

				});

			}
		}
	})
}

function getPassengerData(){


	var customer_email = $('#customerEmail').val();
	var flight_num = $('#flight_num').val();
	var airline_name = $('#airline_name').val();

	var name_list_data = concatName();
	var id_list_data = concatID();
	var phone_list_data=  concatPhone();

	var data = {'passenger_name_list':name_list_data,
				'passenger_id_list':id_list_data,
				'passenger_phone_list':phone_list_data,
				'customer_email':customer_email,
				'airline_name':airline_name,
				'flight_number':flight_num
				};

	console.log(data);
	return data;
	
}

function concatName(){
	var name_list_data = '';
	$('.name-input').each(function(index,data){
		var name = $(this).val();
		name_list_data += name;

		if(index < $('.name-input').length-1){
			name_list_data += ','

		}
	});	

	return name_list_data;
}

function concatID(){
	var id_list_data = '';
	$('.id-input').each(function(index,data){
	var id = $(this).val();
	id_list_data += id;

	if(index < $('.id-input').length-1){
		id_list_data += ','

	}
});	
	return id_list_data;
}

function concatPhone(){
	var phone_list_data = '';
	$('.phone-input').each(function(index,data){
	var phone = $(this).val();
	phone_list_data += phone;

	if(index < $('.phone-input').length-1){
		phone_list_data += ','

		}
	});	
	return phone_list_data;	
}