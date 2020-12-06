$(document).ready(function(){

	console.log($('#login-type').val());

	$('#login').click(function(){
		doLogin();
	})




})


function getLoginData(th){
	var username = $('#userName').val();
	var password = $('#password').val();
	data = {'userName':username,'password':password};
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
					window.location.replace('http://127.0.0.1:5000/eFlight/home/'+type);
				}else{
					console.log('密码错误');
					$('body').LoadingOverlay("hide");
				}
			}
		})
	}

}
