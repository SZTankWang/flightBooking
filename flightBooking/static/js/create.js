$(document).ready(function(){
	$('.btn').button();
	$('.date-input').datepicker();


   		var dateFormat = "mm/dd/yy",
      from = $( "#departure-date" )
        .datepicker({
          defaultDate: "+1w",
          changeMonth: true,
          numberOfMonths: 3
        })
        .on( "change", function() {
          to.datepicker( "option", "minDate", getDate( this ) );
        }),
      to = $( "#arrival-date" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 3
      })
      .on( "change", function() {
        from.datepicker( "option", "maxDate", getDate( this ) );
      });
 
    function getDate( element ) {
      var date;
      try {
        date = $.datepicker.parseDate( dateFormat, element.value );
      } catch( error ) {
        date = null;
      }
 
      return date;
    };

    $('.time-input').timepicker({
	    interval: 60,
	    minTime: '10',
	    maxTime: '6:00pm',
	    defaultTime: '11',
	    startTime: '10:00',
	    dynamic: false,
	    dropdown: true,
	    scrollbar: true


    });

    var pageType = $('#createType').val();
    if(pageType == 'flight'){
    	$('.submit-btn').click(function(){
    		createFlight();
    	})
    }
})

function createFlight(){
	var form = document.getElementById('flight-form');
	var data = new FormData(form);

	$.ajax({
		url:'http://127.0.0.1:5000/eFlight/addNewFlight',
		data:data,
		type:'POST',
	  	processData: false,
	  	contentType: false,
	  	success:function(data){
	  		console.log(data);
	  	}
	})
}