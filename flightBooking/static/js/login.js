$(document).ready(function(){






})


function switchLogin(th){

	//判断当前所处登录类型
	if($(th).attr('id')=='stuff-href'){
		console.log('true');
		//切换到员工登录
		document.getElementById('stuff-href').style.display='none';

		document.getElementById('norm-href').style.display='block';
		switchToStuff();
	}

	if($(th).attr('id') == 'norm-href'){
		document.getElementById('norm-href').style.display='none';

		document.getElementById('stuff-href').style.display='block';
		switchToCustomer();
	}


}

function switchToStuff(){
	$('.login-sub-title').children('p').text('stuff entry');
	$('#userName').attr('placeholder','enter username');
}

function switchToCustomer(){
	$('.login-sub-title').children('p').text('customer/agent entry');
	$('#userName').attr('placeholder','enter email');

}