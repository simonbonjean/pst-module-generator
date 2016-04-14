<script type="text/javascript">
var ajaxUrl = "{$link->getAdminLink('AdminManage')}";
var adminToken='{getAdminToken tab='AdminManage'}';

jQuery(function(){

    $('.position_item .content').click(function(){
        $('.position_item .content').removeClass('selected');
        var item = $(this);
        item.addClass('selected');
        $('#id_parent').val(item.parent().attr('id_parent').replace('radio_item_', ''))
        $('#id_menu_module').val(item.parent().attr('id_menu_module'))

    })
    $('#product_search').typeWatch({
        captureLength: 1,
        highlight: true,
        wait: 750,
        callback: function(){ searchProducts(); }
    });



    $('input[name=guest_only]').change(function(){
        var item = $(this);
        if(item.attr('id') == 'guest_only_off')
            $('.field-member').show(300);
        else
            $('.field-member').hide(300);
    })

    if($('input[name=guest_only]:checked').attr('id') == 'guest_only_off')
        $('.field-member').show(300);
    else
        $('.field-member').hide(300);


    $('input[name=member_only]').change(function(){
        var item = $(this);
        if(item.attr('id') == 'member_only_off')
            $('.field-guest').show(300);
        else
            $('.field-guest').hide(300);
    })

    if($('input[name=member_only]:checked').attr('id') == 'member_only_off')
        $('.field-guest').show(300);
    else
        $('.field-guest').hide(300);








    $('input[name=new_window]').change(function(){
        var item = $(this);
        if(item.attr('id') == 'new_window_off')
            $('.field-lightbox').show(300);
        else
            $('.field-lightbox').hide(300);
    })

    if($('input[name=new_window]:checked').attr('id') == 'new_window_off')
        $('.field-lightbox').show(300);
    else
        $('.field-lightbox').hide(300);


    $('input[name=lightbox]').change(function(){
        var item = $(this);
        if(item.attr('id') == 'lightbox_off')
            $('.field-new_window').show(300);
        else
            $('.field-new_window').hide(300);
    })

    if($('input[name=lightbox]:checked').attr('id') == 'lightbox_off')
        $('.field-new_window').show(300);
    else
        $('.field-new_window').hide(300);












    $('input[name=lightbox]').change(function(){
        var item = $(this);
        if(item.attr('id') == 'lightbox_on')
            $('.box-lightbox').show(300);
        else
            $('.box-lightbox').hide();
    })

    if($('input[name=lightbox]:checked').attr('id') == 'lightbox_on')
        $('.box-lightbox').show(300);
    else
        $('.box-lightbox').hide();


    $('input[name=menu_module]').change(function(){
        var item = $(this);
        var module_name = item.val();


        $('.type_select').each(function(){
            var item = $(this);
            item.attr('disabled','disabled').parent().hide();
        })

        $('.type_select_' + module_name).removeAttr('disabled').parent().show();
    })


    $('.type_select').each(function(){
        var item = $(this);
        item.attr('disabled','disabled').parent().hide();
    })

    $('.type_select_' + $('input[name=menu_module]:checked').val()).removeAttr('disabled').parent().show();




    $('.box-hide').hide();
    var itemChecked = $('input[name=type]:checked');
    $('.box-'+itemChecked.val()).show(300);

    $('input[name=type]').change(function(){
        $('.box-hide').hide();
        var item = $(this);
        $('.box-'+item.val()).show(300);
    })

    function searchProducts()
    {
        $('#products_part').show();
        $.ajax({
            type:"POST",
            url: ajaxUrl,
            async: true,
            dataType: "json",
            data : {
                ajax: "1",
                action: "searchProducts",
                product_search: $('#product_search').val()},
            success : function(res)
            {
                var products_found = '';
                var attributes_html = '';
                var customization_html = '';

                if(res.found)
                {
                    var productLenght = res.products.length;
                    $.each(res.products, function() {


                        if(productLenght == 1)
                            suffix = '{l s=' product found'}';
                        else
                            suffix = '{l s=' products found'}';

                        $('#products_found').show();
                        $('#products_found').html('{l s='There is '}'+productLenght+ suffix)
                        products_found += '<option value="'+this.id_product+'">'+this.name+'</option>';

                        $('#id_product').html(products_found);
                        $('#id_product').change();
                    })
                }
                else
                {
                    $('#products_found').hide();
                    $('#products_err').html('{l s='No products found'}');
                    $('#products_err').show();
                }
                resetBind();

            }
        });

        function resetBind()
        {
            $('.fancybox').fancybox({
                'type': 'iframe',
                'width': '60%',
                'height': '100%'
            });
        }
    }
})

</script>










