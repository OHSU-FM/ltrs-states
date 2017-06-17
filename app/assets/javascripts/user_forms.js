$(document).ready(function(){

	$(document).on('ajax:success', 'form.delete-table-row',function(status){
		$(this).parents('tr').fadeOut(function(){$(this).remove()});
	});

	$(document).on('ajax:send', 'form.delete-table-row',function(status){
		$(this).parents('tr').addClass('spinner-image').
			css("background-color","#FFCCCC").
			find('input, button').each(function(){this.disabled = true});
	});	

});
