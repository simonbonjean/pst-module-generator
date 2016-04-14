$(function(){
    var optionable = function(item){
        var option = item.parent().parent().find('.options');
        if(item.attr('checked') == 'checked')
            option.show();
        else
            option.hide();
    };

    $('.optionable').each(function(){
        optionable($(this));
    });

    $('.optionable').change(function(){
        optionable($(this));
    });
})