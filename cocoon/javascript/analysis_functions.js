/*******************
VISUALIZATION FUNCTIONS
Author: Ethan Gruber
Modification Date: November 2012
Description: Functions used in the Hoard Display and Analyze pipelines
for manipulating forms and rendering tables in the form of highcharts
********************/

$(document).ready(function () {
	$("#tabs").tabs();
	
	/**
	* Visualize an HTML table using Highcharts. The top (horizontal) header
	* is used for series names, and the left (vertical) header is used
	* for category names. This function is based on jQuery.
	* @param {Object} table The reference to the HTML table to visualize
	* @param {Object} options Highcharts options
	*/
	Highcharts.visualize = function (table, options) {
		// the categories
		options.xAxis.categories =[];
		$('tbody th', table).each(function (i) {
			options.xAxis.categories.push(this.innerHTML);
		});
		
		// the data series
		options.series =[];
		$('tr', table).each(function (i) {
			var tr = this;
			$('th, td', tr).each(function (j) {
				if (j > 0) {
					// skip first column
					if (i == 0) {
						// get the name and init the series
						options.series[j - 1] = {
							name: this.innerHTML,
							data:[]
						};
					} else {
						// add values
						options.series[j - 1].data.push(this.innerHTML == 'null'? null: parseFloat(this.innerHTML));
					}
				}
			});
		});
		console.log(options.series);
		
		var chart = new Highcharts.Chart(options);
	}
	
	/** CREATE HIGHCHARTS BASED ON HTML TABLES **/
	$('.calculate').each(function () {
		var id = $(this).attr('id').split('-')[0];
		var formId = $(this).siblings('form').attr('id');
		var type = $('#' + formId + ' input:radio[name=type]:checked').val();
		var chartType = $('#' + formId + ' input:radio[name=chartType]:checked').val();
		
		var table = $(this),
		options = {
			chart: {
				renderTo: id + '-container',
				type: chartType
			},
			title: {
				text: $(this).children('caption').text()
			},
			legend: {
				enabled: true
			},
			xAxis: {
				labels: {
					rotation: - 45,
					align: 'right',
					style: {
						fontSize: '11px',
						fontFamily: 'Verdana, sans-serif'
					}
				}
			},
			yAxis: {
				max: (type == 'count'? null: 100),
				min: (type == 'count'? null: 0),
				title: {
					text: (type == 'percentage'? 'Percentage': 'Occurrences')
				}
			},
			tooltip: {
				formatter: function () {
					return this.y + (type == 'percentage'? '%: ': ' coins: ') + this.x;
				}
			}
		};
		Highcharts.visualize(table, options);
	});
	
	/***** CREATE CHART FOR DATES *****/
	if ($('#dateData').text().length > 0) {
		var data = eval($('#dateData').text());
		var type = $('#date-form input:radio[name=type]:checked').val();
		var chartType = $('#date-form input:radio[name=chartType]:checked').val();
		var chart;
		chart = new Highcharts.Chart({
			chart: {
				renderTo: 'dateChart',
				type: chartType
			},
			title: {
				text: $('#dateData').attr('title')
			},
			xAxis: {
				type: 'datetime',
				labels: {
					rotation: - 45,
					align: 'right',
					formatter: function () {
						var year = this.value;
						if (year < 0) {
							return Math.abs(year) + ' B.C.';
						} else {
							return 'A.D. ' + year;
						}
					}
				}
			},
			yAxis: {
				max: (type == 'count'? null: 100),
				min: (type == 'count'? null: 0),
				title: {
					text: (type == 'count'? 'Occurrences': 'Percentage')
				}
			},
			tooltip: {
				formatter: function () {
					if (this.x < 0) {
						var year = Math.abs(this.x) + ' B.C.';
					} else {
						var year = 'A.D. ' + this.x;
					}
					return this.y + (type == 'count'? ' coins: ': '%: ') + year;
				}
			},
			exporting: {
				enabled: true,
				width: 1200
			},
			series: data
		});
	}
	
	//lock bar and column charts for count in date visualization--line, spine, area, and areaspline for percentages
	$('#date-form input[name=type]').change(function () {
		if ($(this).val() == 'count') {
			//enable quantification-based visualizations
			$('#date-form').find('input[value=bar]').attr('disabled', false);
			$('#date-form').find('input[value=column]').attr('disabled', false);
			//disable percentage-based visualizations
			$('#date-form').find('input[value=line]').attr('disabled', true);
			$('#date-form').find('input[value=area]').attr('disabled', true);
			$('#date-form').find('input[value=spline]').attr('disabled', true);
			$('#date-form').find('input[value=areaspline]').attr('disabled', true);
			
			//set column as default
			$('#date-form').find('input[value=column]').attr('checked', true);
		} else {
			//enable quantification-based visualizations
			$('#date-form').find('input[value=bar]').attr('disabled', true);
			$('#date-form').find('input[value=column]').attr('disabled', true);
			//disable percentage-based visualizations
			$('#date-form').find('input[value=line]').attr('disabled', false);
			$('#date-form').find('input[value=area]').attr('disabled', false);
			$('#date-form').find('input[value=spline]').attr('disabled', false);
			$('#date-form').find('input[value=areaspline]').attr('disabled', false);
			
			//set line as default
			$('#date-form').find('input[value=line]').attr('checked', true);
		}
	});
	
	//disable and re-enable other calculate types in data download form when "cumulative" is selected
	$('#csv-form input[name=type]').change(function () {
		if ($(this).val() == 'cumulative') {
			$('#csv-form input[name=calculate][value!=date]').attr('disabled', true);
			//set date as default
			$('#csv-form input[value=date]').attr('checked', true);
		} else {
			$('#csv-form input[name=calculate]').attr('disabled', false);
		}
	});
	
	//enable cumulative when "date" is checked, otherwise disable
	$('#csv-form input[name=calculate]').change(function () {
		if ($(this).val() == 'date') {
			$('#csv-form input[value=cumulative]').attr('disabled', false);			
		} else {
			$('#csv-form input[value=cumulative]').attr('disabled', true);			
		}
		//set percentage as default
		$('#csv-form input[value=percentage]').attr('checked', true);
	});
	
	//set max number of 4 hoards for comparison (5 shown in total)
	$("#visualize-form .compare-select").livequery('change', function (event) {
		if ($("#visualize-form .compare-option:selected").length > 6) {
			$("#submit-vis").attr("disabled", "disabled");
		} else {
			$("#submit-vis").removeAttr('disabled');
		}
	});
	$("#date-form .compare-select").livequery('change', function (event) {
		if ($("#date-form .compare-option:selected").length > 6) {
			$("#submit-date").attr("disabled", "disabled");
		} else {
			$("#submit-date").removeAttr('disabled');
		}
	});
	/***** GET HOARDS FOR COMPARISON ON DISPLAY PAGE *****/
	$('.compare-button').click(function () {
		//display the compare multiselect list only if it hasn't already been generated
		var cd = $(this).parent().children('.compare-div');
		if (cd.html().indexOf('<option') < 0) {
			$.get('../get_hoards', {
				q: '*'
			},
			function (data) {
				cd.html(data);
			});
		}
		return false;
	});
	
	/***** TOGGLE OPTIONAL SETTINGS *****/
	$('.optional-button').click(function(){
		var formId = $(this).attr('id').split('-')[0] + '-form';
		$('#' + formId + ' .optional-div').toggle('slow');
	});
	
	/***** SUBMIT FORMS *****/
	$('.submit-vis').click(function () {
		var id = $(this).parent('form').attr('id');
		if (id == 'visualize-form') {
			//get calculate facets
			var facets = new Array();
			$('.calculate-checkbox:checked').each(function () {
				facets.push($(this).val());
			});
			var param1 = facets.join(',');
			$(this).siblings('input[name=calculate]').attr('value', param1);
		} else {
			$(this).siblings('input[name=calculate]').attr('value', 'date');
		}
		//get compare value
		var hoards = new Array();
		$('#' + id + ' .compare-option:selected').each(function () {
			hoards.push($(this).val());
		});
		var param2 = hoards.join(',');
		$(this).siblings('input[name=compare]').attr('value', param2);
		
		//get exclude value
		var codes = new Array();
		$('#' + id + ' .exclude-option:selected').each(function () {
			codes.push($(this).val());
		});
		var param3 = codes.join(',');
		$(this).siblings('input[name=exclude]').attr('value', param3);
	});
	
	$('#submit-csv').click(function () {
		var id = $(this).parent('form').attr('id');
		//get compare value
		var hoards = new Array();
		$('#' + id + ' .compare-option:selected').each(function () {
			hoards.push($(this).val());
		});
		var param2 = hoards.join(',');
		$('#' + id + ' .compare-input').attr('value', param2);
		
		//get exclude value
		var codes = new Array();
		$('#' + id + ' .exclude-option:selected').each(function () {
			codes.push($(this).val());
		});
		var param3 = codes.join(',');
		$(this).siblings('input[name=exclude]').attr('value', param3);
	});
	
	/********* FILTERING FUNCTIONS **********/
	$(".showFilter").each(function () {
		var tthis = this;
		$(this).fancybox({			
			onStart: function () {
				var formId = tthis.id.split('-')[0] + '-form';
				alert(formId);
				$('#formId').html(formId);
			}
		});
	});
	
	// total options for advanced search - used for unique id's on dynamically created elements
	var total_options = 1;
	
	// the boolean (and/or) items. these are set when a new search criteria option is created
	var gate_items = {
	};
	
	// focus the text field after selecting the field to search on
	$('.searchItemTemplate select') .change(function () {
		$(this) .siblings('.search_text') .focus();
	})
	
	// assign the gate/boolean button click handler
	$('.gateTypeBtn') .click(function () {
		gateTypeBtnClick($(this), total_options, gate_items);
	})
	
	//filter button activation
	$('#advancedSearchForm').submit(function () {
		var formId = $('#formId').text();
		var q = assembleQuery();
		$('#' + formId + ' .filter-div').children('span').html(q);
		$('#' + formId + ' .filter-div').show();
		$.get('get_hoards', {
			q: q
		},
		function (data) {
			$('#' + formId + ' .compare-div').html(data);
		});
		$.fancybox.close();
		return false;
	});
	
	//remove filter
	$('.removeFilter').click(function () {
		var formId = $('#formId').text();
		$('#' + formId + ' .filter-div').hide();
		$.get('get_hoards', {
			q: '*'
		},
		function (data) {
			$('#' + formId + ' .compare-div').html(data);
		});
		return false;
	})
})