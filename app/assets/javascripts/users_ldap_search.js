$().ready( function(){

    // Automatically perform lookups on input textbox after losing focus and text entered
    $(document).on('focusout', '.ldap_search .ldap_query', function(){
        var node = $(this).parents('.ldap_search');
        query_ldap(node);
    });
        
    $(document).on('cocoon:after-insert'), function(e, intertedItem){
        $(insertedItem).find('.tooltip').each(function(){
            style_tooltip(this);
        });  
    }

});

function get_error_message(data){
    if(typeof(data) == 'undefined'){return false;}
    if(typeof(data.errors) == 'undefined'){return false;}
    var message = '';
    for(var key in data.errors){
        message = message + ' ' + data.errors[key];
    }
    if(message==''){return false;}
    return message;
}

function ui_add_errors(node, message){
    $(node).find('.ldap_query')
        .attr('title', message) 
        .addClass('field_with_errors')
        .tooltip();
    $(node).find('.check_name')
        .removeClass('ui-state-active ui-state-hover')
        .addClass('ui-state-error');  
}

function ui_remove_errors(node){
    $(node).find('.check_name').removeClass('ui-state-error');
    $(node).find('.ldap_query').removeClass('field_with_errors');
}

function enable_ui(node){
    // Re-enable the button and input box
    $(node).find('.check_name')
        .prop('disabled', false);
    $(node).find('.ldap_query')
        .prop('disabled', false)
        .removeClass('result');
}

function disable_ui(node){
    var ldap_query = $(node).find('.ldap_query');
    var button = $(node).find('.check_name'); 
    ldap_query.prop('disabled', true);
    button.prop('disabled', true); 
}

function node_opts(node){
    var opts = {}
    opts.query = {q: $(node).find('.ldap_query').val()};
    opts.url = $(node).find('.ldap_query').data('url');
    return opts;
}

function check_for_logout(data){
    if(typeof(data)!='undefined' && data.status == 401){
        location.reload(true);
    }
}

function query_ldap(node){
    disable_ui(node);
    opts = node_opts(node);
    var q = opts.query.q.toLowerCase();

    // Check for email addresses that are not from ohsu
    if(q.indexOf('@') >= 0 && !q.indexOf('@ohsu.edu') >= 0){
        // Dont search ldap
        ui_remove_errors(node);
        enable_ui(node);
        return;
    }

    // Query server for status on this user
    $.ajax({
        url: opts.url,
        node: node,
        dataType: 'json',
        type: 'get',
        data: opts.query,
        error: function(data){
            check_for_logout(data);
            ui_add_errors(node, ['Network error']);
            enable_ui(node);
        },
        success: function(data){
            var err_msg = get_error_message(data);
            // We weren't able to find the record
            if (data==null || err_msg != false){
                ui_add_errors(node, err_msg);
                enable_ui(node);
                return;
            }

            // remove old errors (if any)
            ui_remove_errors(node);
            
            // update ui
            $(node).find('.ldap_query')
                .val(data.email)
                .attr('title', data.displayname || data.email)
                .tooltip();

            // enable ui
            enable_ui(node);
        }
        
    });
    
}


