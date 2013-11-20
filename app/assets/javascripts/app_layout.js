// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.multiselect
//= require ./jquery.dataTables.min
//= require ./theme_js/bootstrap.min
//= require ./theme_js/theme-elements.min
//= require ./theme_js/theme.min
//= require ./jquery.dataTables.bootstrap
//= require TableTools.min
//= require ckeditor/init

$(document).ready(function(){ 

	$('#iframe_popup_dialog').on('hidden', function () {	    
	    fn_popup_closed_events();
	});

	$("#leave_type_without_pay").click(function(){
		if($(this).is(':checked'))
			$("#hide_without_pay_leave").hide();
		else
			$("#hide_without_pay_leave").show();
	});

 	$(".multi_select_box").multiselect();
});


// Ajax API call initialization with callback function
// initialize_api_call({"url": "/index", "type": "POST", "params": {"title" : "nature"}}, "callback_function", {"id" : 1});
// function callback_function(response, callback_params, api_params){}
// Created At : 11-04-13, Modified At :
function initialize_api_call(api_params, callback, callback_params){
	if(!api_params["params"]) api_params["params"] = {};
	if(!callback_params) callback_params = {};

	$.ajax({
		  url : api_params["url"], type : api_params["type"], data : api_params["params"],
		  success : function(response)
		  {		  	
		  	if(callback && callback != ""){
			  	window[callback](response, callback_params, api_params);
			}
		  	
		  },
		  error : function()
		  {
		  	
		  }
	});
}

function callback_function(response, callback_params, api_params){
	$("#item_data").html(response);
}


function show_box(id) {
   $('.widget-box.visible').removeClass('visible');
   $('#'+id).addClass('visible');
}


function show_iframe_popup(iframe_url, params){
	$('#iframe_popup_dialog').on('show', function (){ 		 
		$('#iframe_popup_header').html(params["header"]);		
     	$('iframe').attr("src", iframe_url);
    });    
    $('#iframe_popup_dialog').modal({show:true});
}
