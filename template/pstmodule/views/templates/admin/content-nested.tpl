{if $show_toolbar && !$isPresta16}
    {include file="toolbar.tpl" toolbar_btn=$toolbar_btn toolbar_scroll=$toolbar_scroll title=$title}
    <div class="leadin">{block name="leadin"}{/block}</div>
{/if}

<style>
{literal}
    .sortable li div.content{
    line-height: 30px;
    }
{/literal}
</style>

<script type="text/javascript">
var ajaxUrl = "{$link->getAdminLink($admin_controller_name)}";
var adminToken = '{getAdminToken tab=$admin_controller_name}';

var success_state_message = "{l s='Update state successful : '}";
var error_state_message = "{l s='Update state error : '}";

var success_sort_message = "{l s='Update sort successful : '}";
var error_sort_message = "{l s='Update sort error : '}";

var success_delete_message = "{l s='Delete item successfully : '}";
var error_delete_message = "{l s='Delete item error : '}";

var customization_errors = false;

var delete_message = "{l s='Do you realy want to delete : '}";

{literal}
$(document).ready(function () {

    $('.actions .delete').click(function () {
        var item = $(this);
        var container = item.parents('li');
        var id_item = container.attr('id').replace('item_', '');
        var title = container.find('.title').html();

        if (confirm(delete_message + title)) {
            $.ajax({
                url: ajaxUrl,
                cache: false,
                data: {
                    ajaxMode: '1',
                    id_item: id_item,
                    submitDelete: '1',
                    action: 'Delete',
                    ajax: '1',
                    token: adminToken
                },
                success: function (res, textStatus, jqXHR) {
                    try {
                        if (res == 'ok') {
                            container.hide(600);
                            showSuccessMessage(success_delete_message + title);
                        }
                        else
                            showErrorMessage(error_delete_message + title);
                    }
                    catch (e) {
                        jAlert('Technical error');
                    }
                }
            });
        }
    })


    $('.actions img.enabled, .actions img.disabled').click(function () {
        var item = $(this);
        var container = item.parents('li');
        var id_item = container.attr('id').replace('item_', '');
        var title = container.find('.title').html();

        var state = item.hasClass('disabled');

        $.ajax({
            url: ajaxUrl,
            cache: false,
            data: {
                ajaxMode: '1',
                state: state,
                id_item: id_item,
                submitUpdateState: '1',
                action: 'UpdateState',
                ajax: '1',
                token: adminToken
            },
            success: function (res, textStatus, jqXHR) {
                try {
                    if (res == 'ok') {
                        if (state) {
                            item.parent().find('.disabled').hide();
                            item.parent().find('.enabled').show();
                        }
                        else {
                            item.parent().find('.disabled').show();
                            item.parent().find('.enabled').hide();
                        }
                        showSuccessMessage(success_state_message + title);
                    }
                    else
                        showErrorMessage(error_state_message + title);
                }
                catch (e) {
                    jAlert('Technical error');
                }
            }
        });
    });


    var sortUpdateTree = function (event, ui) {
        var title = ui.item.parents('fieldset').find('legend').text();
        $.ajax({
            url: ajaxUrl,
            cache: false,
            data: {
                ajaxMode: '1',
                items: ui.item.parents('.sortable').nestedSortable('toArray'),
                submitUpdateSort: '1',
                action: 'UpdateSortTree',
                ajax: '1',
                token: adminToken
            },
            success: function (res, textStatus, jqXHR) {
                try {
                    if (res == 'ok')
                        showSuccessMessage(success_sort_message + title);
                    else
                        showErrorMessage(error_sort_message + title);
                }
                catch (e) {
                    jAlert('Technical error');
                }
            }
        });
    };

    $('.sortable').nestedSortable({
        handle: 'div',
        helper: 'clone',
        items: 'li',
        listType: 'ol',
        opacity: .6,
        placeholder: 'placeholder',
        revert: 250,
        tabSize: 25,
        tolerance: 'pointer',

        isTree: true,
        expandOnHover: 700,

        update: sortUpdateTree
    })


    $('.disclose').on('click', function () {
        $(this).closest('li').toggleClass('mjs-nestedSortable-collapsed').toggleClass('mjs-nestedSortable-expanded');
    })


    {/literal}

});

</script>
{$item_list}