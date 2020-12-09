$(document).ready(function(){
	getRecord();
	var height = $(window).height();
	var width = $(window).width();

	$('#view').selectmenu({
	    select: function() {
        if($(this).val() != '') {
            window.location.href = $(this).val();
        }
    }

	});

	$('.date-input').datepicker({
		dateFormat:"yy-mm-dd"
	}
		

	);

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

	$('#status').selectmenu({
		  select: function( event, ui ) {
		  	console.log($(this).val());
		  	var selected = $(this).val();
		  	$('#select-status').val(selected);

		  }
		});

	$('#apply').click(function(){
		getRecord();
	})
})


function getRecord(){
	var startDate = $('#start-date').val();
	var endDate  = $('#end-date').val();
	var departure = $('#departure').val();
	var arrival = $('#arrival').val();
	var status = $('#select-status').val();
	var data = {'startDate':startDate,'endDate':endDate,'departure':departure,'arrival':arrival,'status':status};
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/staffViewFlights',
		data:data,
		success:function(response){
			console.log(response);
		}

	})
}