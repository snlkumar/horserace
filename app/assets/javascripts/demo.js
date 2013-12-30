/*
 * Another In Place Editor - a jQuery edit in place plugin
 *
 * Copyright (c) 2009 Dave Hauenstein
 *
 * License:
 * This source file is subject to the BSD license bundled with this package.
 * Available online: {@link http://www.opensource.org/licenses/bsd-license.php}
 * If you did not receive a copy of the license, and are unable to obtain it,
 * email davehauenstein@gmail.com,
 * and I will send you a copy.
 *
 * Project home:
 * http://code.google.com/p/jquery-in-place-editor/
 *
 */
$(document).ready(function(){
	
	
var token= $('meta[name="csrf-token"]').attr('content');
var data={
		"authenticity_token": token
	};
	
	// A select input field so we can limit our options
	$("#editme3").editInPlace({
		url: '/races/update_status?',
		field_type: "select",
		select_options: "win, lost",
		params: data
	});

	
});