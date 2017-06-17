function style_tooltip(node){
    $(node).qtip();    
}

$(document).ready(function(){
    $('.dropdown-toggle').dropdown()
    $(document).on('create', '.tooltip', function(){
        $(this).tooltip();
    });
    $('input[type="date"]').prop('type','').datepicker({format: "yyyy-mm-dd"});

	$('[data-toggle="tooltip"]').tooltip()

    // Close popovers when we click outside of the box
    $('body').on('click', function (e) {
        $('[data-toggle="popover"]').each(function () {
            //the 'is' for buttons that trigger popups
            //the 'has' for icons within a button that triggers a popup
            if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                $(this).popover('hide');
            }
        });
    });
}); 

