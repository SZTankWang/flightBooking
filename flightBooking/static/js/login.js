$(document).ready(function(){

	console.log($('#login-type').val());

	$('#login').click(function(){
		doLogin();
	})

	document.onkeydown=function(event){
		var code = event.keyCode;
		if(code ==13){
			doLogin();
		}
	}



})


function getLoginData(th){
	var username = $('#userName').val();
	var password = $('#password').val();
	var next = $('#next').val();
	data = {'userName':username,'password':password,'next':next};
	return data;
}

function infoChecker(data){
	if (data['userName'] == '' || data['password']==''){
		return -1;
	}
	return 0;
}

function doLogin(){
	$('body').LoadingOverlay("show");
	var data = getLoginData();
	var type = $('#login-type').val();
	var next = $('#next').val();
	data['type'] = type;
	if(infoChecker(data)==0){
		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/doLogin',
			type:'POST',
			data:data,
			success:function(data){
				if(data['code']==0){
					console.log('验证成功');
					$('body').LoadingOverlay("hide");
					window.location.href='http://127.0.0.1:5000/eFlight/home';
				}else{
					console.log('密码错误');
					$('body').LoadingOverlay("hide");
				}
			}
		})
	}

}
