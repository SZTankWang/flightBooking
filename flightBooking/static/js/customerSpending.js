$(document).ready(function(){
		console.log('hi');
		$('.btn').button();

		$('.left-search').click(function(){
			var startDate = $('#leftStartDate').val();
			var endDate = $('#leftEndDate').val();


			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/trackDateSpending',
				data:{'startDate':startDate,'endDate':endDate},
				success:function(data){
					console.log(data);
					$('#amount-of-ticket').html('you spend: '+data);
				}

			})


		})

		$('.right-search').click(function(){
			var startMonth = $('#startDateRight').val();
			var endMonth = $('#endDateRight').val();


			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/trackMonthSpending',
				data:{'startMonth':startMonth,'endMonth':endMonth},
				success:function(data){
					console.log(data);
					var mychart = echarts.init(document.getElementById('barchart'));

					drawBarChartForReport(data,mychart);
				}

			})
		})

		


})

function drawBarChartForReport(data,mychart){
	var months = [];
	var tickets = [];


	for(var i =0; i<data.length;i++){
		var month = data[i]['month'];
		var number = data[i]['spending'];
		months.push(month);
		tickets.push(number);
	}


	option = {
	    xAxis: {
	        data: months
	    },
	    yAxis: {
	    },
	    series: [{
	        data: tickets,
	        type: 'bar',
	        showBackground: true,
	        backgroundStyle: {
	            color: 'rgba(220, 220, 220, 0.8)'
	        }
	    }]
	};

	mychart.setOption(option);
}
