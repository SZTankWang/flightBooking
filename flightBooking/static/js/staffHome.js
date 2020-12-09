$(document).ready(function(){

	var height = $(window).height();
	var width = $(window).width();

	$('.select').selectmenu({
	    select: function() {
        if($(this).val() != '') {
            window.location.href = $(this).val();
        }
    }

	});

	$('.date-input').datepicker();

	$('.btn').button();

	$('.update-dialog').dialog({
		autoOpen:false,
		modal:true,
		height:height*0.3,
		width:width*0.3


	});

	$('.info-dialog').dialog({
		autoOpen:false,
		modal:true,
		height:height*0.6,
		width:width*0.3


	});	


	$('.update').click(function(){
		$('.update-dialog').dialog('open');

		$('.status-select').selectmenu();
	})

	$('.info').click(function(){
		$('.info-dialog').dialog("open");
	})



})