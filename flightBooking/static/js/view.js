$(document).ready(function(){
	var pageType = $('#viewType').val();
	console.log(pageType);
	if(pageType == 'customer'){

		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/viewFrequentCustomer',
			type:'GET',
			success:function(data){
				console.log(data);
				$('#top-customer').html(data['customer_email']);
				$('#top-ticket-count').html(data['number']);
			}
			});


	};

	if(pageType == 'bookingAgent'){

		$.ajax({
			url:'http://127.0.0.1:5000/eFlight/viewBookingAgent',
			type:'GET',
			success:function(data){
				console.log(data);
				var month_ticket = data['month_ticket_result'];
				var year_ticket = data['year_ticket_result'];
				var commission_result = data['year_commission_result'];
				$('.month-result-container').empty();
				$('.year-result-container').empty();
				$('.commission-result-container').empty();
				for(var i=0;i<month_ticket.length;i++){
					var html = agentMonthTemplate(month_ticket[i]);
					$('.month-result-container').append(html);
				}

				for(var i=0;i<commission_result.length;i++){
					var html = agentCommissionTemplate(commission_result[i]);
					$('.commission-result-container').append(html);
				}				

				for(var i=0;i<year_ticket.length;i++){
					var html = agentMonthTemplate(year_ticket[i]);
					$('.year-result-container').append(html);
				}	



			}
			});

	}

	if(pageType == 'report'){
		console.log('hi');
		$('.btn').button();

		$('.left-search').click(function(){
			var startDate = $('#leftStartDate').val();
			var endDate = $('#leftEndDate').val();


			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/viewDateReport',
				data:{'startDate':startDate,'endDate':endDate},
				success:function(data){
					console.log(data);
					$('#amount-of-ticket').html(data['ticket_number']);
				}

			})


		})

		$('.right-search').click(function(){
			var startMonth = $('#startDateRight').val();
			var endMonth = $('#endDateRight').val();


			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/viewMonthReport',
				data:{'startMonth':startMonth,'endMonth':endMonth},
				success:function(data){
					console.log(data);
					var mychart = echarts.init(document.getElementById('barchart'));

					drawBarChartForReport(data,mychart);
				}

			})
		})

		}

		if(pageType == 'revenue'){
			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/compareRevenue',
				success:function(data){
					console.log(data);
					var mychart1 = echarts.init(document.getElementById('chart1'));
					var mychart2 = echarts.init(document.getElementById('chart2'));
					drawPieChartForRevenue(data,mychart1,mychart2);
				}

			})
		}

		
		if(pageType == 'topDestination'){
			$.ajax({
				url:'http://127.0.0.1:5000/eFlight/viewTopDestinations',
				success:function(data){
					console.log(data);
					var destination = '';
					var count = '';
					for(var i =0;i<data.length;i++){
						dest = strongTextTemplate1(data[i]);
						cnt = strongTextTemplate2(data[i]);
						destination += dest;
						count+= cnt;
					}	
					$('.dst-container').append(destination);
					$('.count-container').append(count);
				}

			})
		}

		if(pageType == "agentCommission"){
			$('#commission-search').button();
			$('.commission-date-input').datepicker({
				dateFormat: "yy-mm-dd"


			})

			var today = moment().format('YYYY-MM-DD');
			queryAgentCommission('',today);

			$('#commission-search').click(function(){
				var startDate = $('#commission-start').datepicker( "getDate" );
				start = moment(startDate).format('YYYY-MM-DD');
				var endDate  =  $('#commission-end').datepicker( "getDate");
				end = moment(endDate).format('YYYY-MM-DD');

				queryAgentCommission(start,end);

			})

		}

		if(pageType == "topCustomer"){
			drawBarCharForAgent();
		}

})

function queryAgentCommission(start,end){
	$('#start').html(start);
	$('#end').html(end);

	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/viewCommission',
		data:{'startDate':start,'endDate':end},
		success:function(res){
			console.log(res);


			$('.commission-result-sum').empty();
			$('.commission-result-avg').empty();
			if(res.length >0){
				var sum = '<p>'+res[0]['sum']+'</p>';
				var avg = '<p>'+res[0]['avg']+'</p>';


				$('.commission-result-sum').html(sum);
				$('.commission-result-avg').html(avg);			
			}
			else{
				var sum = '<p>no ticket bought within this range</p>';
				var avg = '<p>no ticket bought within this range</p>';


				$('.commission-result-sum').html(sum);
				$('.commission-result-avg').html(avg);		
			}

		}

	})
}




function strongTextTemplate1(data){
	var html = '';
	html += '<div class="strong-text-container">';
	html += '<p>' + data['airport_city'] + '</p>';
	html += '</div>';
	return html;

}

function strongTextTemplate2(data){
	var html = '';
	html += '<div class="strong-text-container">';
	html += '<p>' + data['count(ticket_id)'] + '</p>';
	html += '</div>';
	return html;

}


function agentMonthTemplate(data){
	var html ='';
	html += '<div class="my-container agent-container">';
	html += '<p>'+ data['booking_agent_id'] + '</p>&nbsp&nbsp';
	html += '<p>sold </p>&nbsp';
	html += '<p>' + data['count(ticket_id)'] + '</p>&nbsp';
	html += '<p>ticket(s)</p>';
	return html;
}


function agentCommissionTemplate(data){
	var html ='';
	html += '<div class="my-container agent-container">';
	html += '<p>'+ data['booking_agent_id'] + '</p>&nbsp&nbsp';
	html += '<p>sold price of </p>&nbsp';
	html += '<p>' + data['sum(price)'] + '</p>&nbsp';
	// html += '<p></p>';
	return html;
}

function drawBarCharForAgent(){
	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/viewTopCustomer',
		success:function(res){
			console.log(res);
			var mychart1 = echarts.init(document.getElementById('agentchart1'));
			var mychart2 = echarts.init(document.getElementById('agentchart2'));
	          var height= $(window).height();//浏览器的高度 
	          mychart1.getDom().style.height = height*0.2;
	          mychart1.resize(); 
			agentBarChartYear(res['commission'],mychart1);
			agentBarMonth(res['ticket'],mychart2);
		}
	})



}

function agentBarChartYear(data,mychart){
	var emails = [];
	var commissions = [];
	for(var i=0;i<data.length;i++){
		emails.push(data[i]['customer_email']);
		commissions.push(data[i]['total_commission']);
	}

	option = {
    title: {
        text: 'commission for last year',
        left: 'center',
        top: 20,
        textStyle: {
            color: '#225DA3',
            weight:500
        }
    },
    xAxis: {
        type: 'category',
        data: emails
            },
    yAxis: {
        type: 'value'
    },
    series: [{
        data: commissions,
        type: 'bar',
        showBackground: true,
        backgroundStyle: {
            color: 'rgba(220, 220, 220, 0.8)'
        }
    }]
};
	mychart.setOption(option);

}


function agentBarMonth(data,mychart){
		var emails = [];
	var commissions = [];
	for(var i=0;i<data.length;i++){
		emails.push(data[i]['customer_email']);
		commissions.push(data[i]['count']);
	}

	option = {
    title: {
        text: 'commission for last 6 month',
        left: 'center',
        top: 20,
        textStyle: {
            color: '#225DA3',
            weight:500
        }
    },
    xAxis: {
        type: 'category',
        data: emails
            },
    yAxis: {
        type: 'value'
    },
    series: [{
        data: commissions,
        type: 'bar',
        showBackground: true,
        backgroundStyle: {
            color: 'rgba(220, 220, 220, 0.8)'
        }
    }]
};
	mychart.setOption(option);

}

function drawBarChartForReport(data,mychart){
	var months = [];
	var tickets = [];


	for(var i =0; i<data.length;i++){
		var month = data[i]['month'];
		var number = data[i]['ticket_number'];
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


function drawPieChartForRevenue(data,mychart1,mychart2){

	var data1 = data['month_result'][0];
	var data2 = data['year_result'][0];	

	dataChart1 = [{value:data1['agent_num_ticket'],name:'agent revenue'},{value:data1['customer_num_ticket'],name:'customer revenue'}];
	dataChart2 = [{value:data2['agent_num_ticket'],name:'agent revenue'},{value:data2['customer_num_ticket'],name:'customer revenue'}];


	option1 = {
    backgroundColor: '#f1f1f1',

    title: {
        text: 'revenue comparison for last month',
        left: 'center',
        top: 20,
        textStyle: {
            color: '#225DA3',
            weight:500
        }
    },

    tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b} : {c} ({d}%)'
    },

    visualMap: {
        show: false,
        min: 80,
        max: 600,
        inRange: {
            colorLightness: [0, 1]
        }
    },
    series: [
        {
            name: 'buyer type',
            type: 'pie',
            radius: '55%',
            center: ['50%', '50%'],
            data: dataChart1.sort(function (a, b) { return a.value - b.value; }),
            roseType: 'radius',
            label: {
                color: 'rgba(23, 111, 211, 0.3)'
            },
            labelLine: {
                lineStyle: {
                    color: 'rgba(23, 111, 211, 0.3)'
                },
                smooth: 0.2,
                length: 10,
                length2: 20
            },
            itemStyle: {
                color: '#225DA3',
                shadowBlur: 200,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
            },

            animationType: 'scale',
            animationEasing: 'elasticOut',
            animationDelay: function (idx) {
                return Math.random() * 200;
            }
        }
    ]
};

option2 = {
    backgroundColor: '#f1f1f1',

    title: {
        text: 'revenue comparison for last year',
        left: 'center',
        top: 20,
        textStyle: {
            color: '#225DA3',
            weight:500
        }
    },

    tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b} : {c} ({d}%)'
    },

    visualMap: {
        show: false,
        min: 80,
        max: 600,
        inRange: {
            colorLightness: [0, 1]
        }
    },
    series: [
        {
            name: 'buyer type',
            type: 'pie',
            radius: '55%',
            center: ['50%', '50%'],
            data:dataChart2.sort(function (a, b) { return a.value - b.value; }),
            roseType: 'radius',
            label: {
                color: 'rgba(23, 111, 211, 0.3)',
                weight:600
            },
            labelLine: {
                lineStyle: {
                    color: 'rgba(23, 111, 211, 0.3)'
                },
                smooth: 0.2,
                length: 10,
                length2: 20
            },
            itemStyle: {
                color: '#225DA3',
                shadowBlur: 200,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
            },

            animationType: 'scale',
            animationEasing: 'elasticOut',
            animationDelay: function (idx) {
                return Math.random() * 200;
            }
        }
    ]
};
			mychart1.setOption(option1);
			mychart2.setOption(option2);
}



