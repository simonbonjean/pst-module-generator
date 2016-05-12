<?php
/**
 * @since 1.5.0
 */
class Admin{$entity_model}Controller extends PstAdminController
{

    protected $position_identifier = '{$entity}';

    public function __construct()
    {
        $this->bootstrap = true;
        $this->context = Context::getContext();
        $this->table = 'pst_{$entity}';
        $this->className = '{$entity_model}';
        $this->identifier = 'id_{$entity}';
        $this->module_name = '{$module_name|strtolower}';
        $this->lang = {if $is_multi_lang}true{else}false{/if};
{if $has_image}
        $this->fieldImageSettings = array();
{/if}
        $this->_virtual_item_list = array();
{foreach $fields as $field}{if isset($field.callback) && $field.type == 'image'}
        $this->_virtual_item_list[] = '{$field.name}';
{/if}{/foreach}
{foreach $fields as $field}{if $field.type == 'image'}

        $this->fieldImageSettings[] = array(
            'name' => '{$field.name}',
            'dir' => '{$module_name|strtolower}/{$entity|strtolower}/{$field.name}'
        );
        $dir = _PS_IMG_DIR_.'{$module_name|strtolower}/{$entity|strtolower}/{$field.name}';
        if(!is_dir($dir))
            mkdir($dir,0777, true);
{/if}{/foreach}

{foreach $fields as $field}{if $field.type == 'image_ml'}
        foreach(Language::getLanguages() as $lang)
        {
            $iso_code = $lang['iso_code'];
            $this->fieldImageSettings[] = array(
                'name' => '{$field.name}_'.$iso_code,
                'dir' => 'superblock/{$field.name}/'.$iso_code
            );

            $dir = _PS_IMG_DIR_.'{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$iso_code;
            if(!is_dir($dir))
                mkdir($dir,0777, true);
        }
{/if}{/foreach}

        parent::__construct();
        $this->addTemplateDir('views/templates/admin');
        $this->multiple_fieldsets = true;

        $this->fields_list = array(
            'id_{$entity}' => array(
                'title' => $this->l('ID'),
                'align' => 'center',
                'width' => 25
            ),

{foreach $fields as $field}{if !$field.rte && $field.type != 'id_entity' && $field.type != 'many_entity'}
            '{$field.name}' => array(
                'title' => $this->l('{$field.name|ucfirst|replace:'_':' '}'),
                'width' => 'auto',
                'lang' => {if $field.is_multi_lang}true{else}false{/if},
{if isset($field.callback)}
                'callback'=>'{$field.callback}{$field.name|ucfirst}',
{/if}
            ),
{/if}
{/foreach}

{if $option.active}
            'active' => array(
                'title' => $this->l('Enabled'),
                'width' => '70',
                'align' => 'center',
                'active' => 'status',
                'type' => 'bool',
                'orderby' => false
            ),
{/if}
{if $option.sortable_flat}
            'position' => array(
                'title' => $this->l('Position'),
                'width' => 40,
                'filter_key' => 'a!position',
                'position' => 'position'
            )
{/if}
        );
        $this->bulk_actions = array(
            'delete' => array('text' => $this->l('Delete selected'), 'confirm' => $this->l('Delete selected items?')),
            'enableSelection' => array('text' => $this->l('Enable selection')),
            'disableSelection' => array('text' => $this->l('Disable selection'))
        );
    }
{if $option.sortable_nested}
    public function initContent(){
        $this->context->smarty->assign(array(
            'admin_controller_name'=>'Admin{$entity_model}'
        ));
        $this->setTemplate('content-nested.tpl');
        parent::initContent();
    }

    public function ajaxProcessDelete()
    {
        if (Tools::isSubmit('submitDelete')) {
            $item = new {$entity_model}(Tools::getValue('id_item'));
            if (Validate::isLoadedObject($item)) {
                $item->delete();
                die('ok');
            }
        }
    }
{if $option.active}
    public function ajaxProcessUpdateState()
    {
        if (Tools::isSubmit('submitUpdateState')) {
            $item = new {$entity_model}(Tools::getValue('id_item'));
        if (Validate::isLoadedObject($item)) {
            $state = Tools::getValue('state') == 'true';
            $item->active = $state;

            if ($item->save())
                die('ok');
            }
        }
    }
{/if}
    public function ajaxProcessUpdateSortTree()
    {
        if (Tools::isSubmit('submitUpdateSort')) {
            $items = Tools::getValue('items');
            $id_parent = null;
            $cpt = 0;
            foreach ($items as $item) {

                if ($item['item_id'] == 'null' || $item['item_id'] == '')
                    continue;

                $itemToUpdate = new {$entity_model}((int)$item['item_id']);

                if (Validate::isLoadedObject($itemToUpdate)) {
                    $itemToUpdate->id_{$entity} = Tools::getValue('id_{$entity}');
                    $itemToUpdate->id_parent = ((int)$item['parent_id'] != 'null') ? (int)$item['parent_id'] : 0;
                    $itemToUpdate->nleft = (int)$item['left'];
                    $itemToUpdate->nright = (int)$item['right'];
                    $itemToUpdate->level_depth = (int)$item['depth'];
                    $itemToUpdate->position = $cpt++;
                    $itemToUpdate->save();
                } else {
                    die('error');
                }
            }
            die('ok');
        }
        die('error');
    }
{/if}
    public function setMedia()
    {
        parent::setMedia();
        $this->addJqueryUI('ui.dialog');
{if $option.sortable_nested}
        $this->addJqueryUI('ui.sortable');
        $this->addCSS($this->core_module_web_path . 'admin/js/jquery.mjs.nestedSortable.css', 'all');
        $this->addJS($this->core_module_web_path . 'admin/js/jquery.mjs.nestedSortable.js');
{/if}
        $this->addJqueryPlugin(array('autocomplete', 'fancybox', 'typewatch'));
        $this->addCSS($this->module_web_path . 'admin/css/global.css', 'all');
    }

{if $option.sortable_nested}

    public function getItems($id_lang, {if $option.active}$active_only = true, {/if}$id_parent = 0){

        $query = 'SELECT a.*, b.*
                    FROM `' . _DB_PREFIX_ . 'pst_{$entity}` a
                    LEFT JOIN `' . _DB_PREFIX_ . 'pst_{$entity}_lang` b ON (a.`id_{$entity}` = b.`id_{$entity}` AND b.`id_lang` = ' . (int)$id_lang . ')
                    WHERE  a.`id_parent` = ' . (int)$id_parent . ' ' {if $option.active}. ($active_only ? 'AND a.`active` = 1' : '') {/if}. '
                    ORDER BY a.`position` ASC';


        $results = Db::getInstance()->ExecuteS($query);
        foreach ($results as $k => $result) {
            if (is_array($result) && count($result)) {
                $results[$k]['childrens'] = $this->getItems($id_lang, {if $option.active}$active_only, {/if}$result['id_{$entity}']);
            }
        }
        return $results;
    }

    public function getListItem($items){
        $_html = '';
        foreach($items as $item){
            $_html .= '<li id="item_'.$item['id_{$entity}'].'">';
            $_html .= '<div class="content">';
            if(isset($item['childrens']))
                $_html .= '<span classd="disclose"></span>';
            $_html .= '<span class="title">'.$item[{$entity_model}::getTitle()].'</span>';
            $_html .= $this->getActions($item);
            $_html .= '</div>';

            if(isset($item['childrens']))
                $_html .= '<ol>'. $this->getListItem($item['childrens']) .'</ol>';
            $_html .= '</li>';
        }
        return $_html;
    }
{/if}


    public function getActions($item)
    {
        $_html = '';
        $_html .='<span class="actions">';

{if $option.active}
        if($item['active'])
        {
            $disabled_style = 'style="display: none" ';
            $enabled_style = '';
        }
        else{
            $enabled_style = 'style="display: none" ';
            $disabled_style = '';
        }
        $_html .= '<img '.$enabled_style.'src="'._PS_ADMIN_IMG_.'enabled.gif" alt="enabled" class="enabled pointer action" />';
        $_html .= '<img '.$disabled_style.'src="'._PS_ADMIN_IMG_.'disabled.gif" alt="disabled" class="disabled pointer action" />';

{/if}
        $_html .= $this->helper_list->displayEditLink(null,$item['id_{$entity}']);
        $_html .= '<img src="'._PS_ADMIN_IMG_.'delete.gif" alt="delete" class="delete pointer action" />';
        $_html .= '</span>';

        return $_html;

    }

    public function renderList()
    {
{if $option.sortable_nested}
        $this->helper_list = new HelperList();
        {*$this->setHelperDisplay($this->getHelper());*}
        $this->setHelperDisplay($this->helper_list);

        $url = Context::getContext()->link->getAdminLink('Admin{$entity_model}') . '&add'.$this->table.'=1';

        $item_list = '<fieldset  class="panel box_menu" style="min-width: 500px;">';
        $item_list .= '<div class="panel-heading">'.$this->l('{$front_name}');
        $item_list .= '<span class="panel-heading-action">';
        $item_list .= '<a class="list-toolbar-btn" href="'.$url.'">';
        $item_list .= ' <span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="Ajouter" data-html="true">';
        $item_list .= '     <i class="process-icon-new "></i>';
        $item_list .= ' </span>';
        $item_list .= '</a>';
        $item_list .= '</span>';
        $item_list .= '</div>';
        $item_list .= '<ol class="sortable">';
        $item_list .= $this->getListItem($this->getItems($this->id_lang{if $option.active}, false{/if}));
        $item_list .= '</ol>';
        $item_list .= '<div class="clear"></div>';
        $item_list .= '</fieldset>';

        $this->context->smarty->assign(array(
            'show_toolbar' => true,
            'helperList'=> $this->helper_list,
            'toolbar_btn' => $this->toolbar_btn,
            'title' => array($this->table . $this->l('Manager'), $this->l('List')),
            'item_list' => $item_list,
            'module_name' => $this->module_name,
        ));
{else}
        $this->addRowAction('edit');
        $this->addRowAction('delete');
{if $option.sortable_flat}
        $this->_orderBy = 'position';
{/if}
{/if}

        return parent::renderList();
    }

    public function getFieldsValues($obj)
    {
        parent::getFieldsValue($obj);
    }

    public function postProcess()
    {
        if (Tools::getValue('forcedeleteImage', false))
        {
            $this->processForceDeleteImage();
            $this->displayInformation('Image is removed');
            Tools::redirectAdmin(self::$currentIndex.'&'.$this->identifier.'='.$this->object->id.'&update'.$this->table.'&token='.Tools::getAdminTokenLite('Admin{$entity_model}'));
        }
        return parent::postProcess();
    }

    public function renderForm()
    {
        if (!($obj = $this->loadObject(true)))
            return;

{foreach $fields as $field}{if $field.type == 'image'}

        $ext = 'jpg';
        $image_{$field.name} = file_exists(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$obj->id.'.jpg');
        if(!$image_{$field.name})
        {
            $ext = 'png';
            $image = file_exists(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$obj->id.'.png');
        }
        $image_size_{$field.name} = $image_url_{$field.name} = false;
        if($image_{$field.name})
        {
            $image_url_{$field.name} = PstImage::cacheResizeCustomPath( '/img/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/', $obj->id.'.'.$ext, 150,150);
            $image_url_{$field.name} = $image_{$field.name} ? '<img src="'.$image_url_{$field.name}.'" />' : false;
            $image_size_{$field.name} = filesize(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$obj->id.'.'.$ext) / 1000 ;
        }

{/if}{/foreach}

        $fields = array(
            'legend' => array(
                'title' => $this->l('{$front_name}')
            ),

            'input' => array()
        );

{foreach $fields as $field}{if $field.type !='image_ml'}
        $current = array(
                    'type' => '{$field.form_type}',
                    'label' => $this->l('{if !empty($field.desc)}{$field.desc}{else}{$field.name|ucfirst|replace:'_':' '}{/if}:'),
                    'name' => '{$field.name}',
{if $field.required}
                    'required' => false,
{/if}


{if $field.type =='image'}
                    'display_image' => true,
                    'image' => $image_url_{$field.name} ? $image_url_{$field.name} : false,
                    'size' => $image_size_{$field.name},
{if !$field.required}
                    'delete_url' => self::$currentIndex.'&'.$this->identifier.'='.$obj->id.'&token='.$this->token.'&forcedeleteImage=1&name={$field.name}',
{/if}
{/if}
                    'class' => 't',
{if $field.is_bool}
                    'is_bool' => true,
                    'values' => array(
                        array(
                            'id' => 'active_on',
                            'value' => 1,
                            'label' => $this->l('Enabled')
                        ),
                        array(
                            'id' => 'active_off',
                            'value' => 0,
                            'label' => $this->l('Disabled')
                        )
                    ),
{/if}
{if !empty($field.desc)}
                    'desc' => $this->l('{$field.desc}'),
{/if}
                    'lang' => {if $field.is_multi_lang}true{else}false{/if},
{if $field.rte}
                    'autoload_rte' => true,
                    'rows' => 5,
                    'cols' => 40,
                    'hint' => $this->l('Invalid characters:').' <>;=#{}'
{/if}
        );
{/if}
{if $field.type =='id_entity'}
        if({$field.entity}::isTree())
        {
            $items = {$field.entity}::getList($this->context->language->id {if $field.required},true{/if});
            $id_selected_item = 1;
            if(isset($this->object->id))
            {
                $id_selected_item = $this->object->{$field.name};
            }

            $html_tree = {$field.entity}::recurseTree($items, $id_selected_item);
            $current['type'] = 'select_html';
            $current['options'] = array('html' => $html_tree);
        }
        else
        {
            $current['options'] = array(
                'query' => {$field.entity}::getList($this->context->language->id{if $field.required},true{/if}),
                'name'=>'name',
                'id'=>'id'
            );
        }
{/if}
{if $field.type =='many_entity'}
        if({$field.entity}::isTree())
        {
            $items = {$field.entity}::getList($this->context->language->id, true);
            $selected_items = array();
            if(isset($this->object->id))
            {
                $selected_items = {$entity_model}::getManyId('{$field.entity}',$this->object->id);
            }
            $html_tree = {$field.entity}::recurseManyTree($items, '{$field.name}', $selected_items);
            $current['type'] = 'checkbox_html';
            $current['options'] = array('html' => $html_tree);
        }
        else
        {
            $selected_items = {$entity_model}::getManyId('{$field.entity}',$this->object->id);
            foreach($selected_items as $id => $item)
                $this->fields_value['{$field.name}_' .$id] = boolval($item);
            $current['type'] = 'checkbox';
            $current['values'] = array(
                    'query' => {$field.entity}::getList($this->context->language->id, true),
                    'id' => 'id',
                    'name' => 'name'
            );
        }
{/if}
        if(isset($current))
            $fields['input'][] = $current;
{/foreach}



{foreach $fields as $field}{if $field.type == 'image_ml'}

        $ext = 'jpg';
        $image = file_exists(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$obj->id.'.jpg');
        if(!$image)
        {
            $ext = 'png';
            $image = file_exists(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$obj->id.'.png');
        }
        $image_size = $image_url = false;

        if($image)
        {
            $image_url = PstImage::cacheResizeCustomPath( '/img/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/', $obj->id.'.'.$ext, 150,150);
            $image_url = $image ? '<img src="'.$image_url.'" />' : false;
            $image_size = filesize(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$obj->id.'.'.$ext) / 1000 ;
        }
        $fields['input'][] = array(
            'type' => 'file',
            'label' => $this->l('{$field.name}') . ' default :',
            'name' => '{$field.name}',
            'display_image' => true,
            'image' => $image_url ? $image_url : false,
            'size' => $image_size,
            'delete_url' => self::$currentIndex.'&'.$this->identifier.'='.$obj->id.'&token='.$this->token.'&forcedeleteImage=1&name={$field.name}'
        );
        foreach(Language::getLanguages() as $lang)
        {
            $iso_code = $lang['iso_code'];
            $ext = 'jpg';
            $image = file_exists(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$iso_code.'/'.$obj->id.'.jpg');
            if(!$image)
            {
                $ext = 'png';
                $image = file_exists(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$iso_code.'/'.$obj->id.'.png');
            }
            $image_size = $image_url = false;
            if($image)
            {
                $image_url = PstImage::cacheResizeCustomPath( '/img/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$iso_code.'/', $obj->id.'.'.$ext, 150,150);
                $image_url = $image ? '<img src="'.$image_url.'" />' : false;
                $image_size = filesize(_PS_IMG_DIR_.'/{$module_name|strtolower}/{$entity|strtolower}/{$field.name}/'.$iso_code.'/'.$obj->id.'.'.$ext) / 1000 ;
            }


            $fields['input'][] = array(
                'type' => 'file',
                'label' => $this->l('{$field.name}') . ' ' . $iso_code . ':',
                'name' => '{$field.name}_'. $iso_code,
                'display_image' => true,
                'image' => $image_url ? $image_url : false,
                'size' => $image_size,
                'delete_url' => self::$currentIndex.'&'.$this->identifier.'='.$obj->id.'&token='.$this->token.'&forcedeleteImage=1&name={$field.name}'
            );
        }
{/if}{/foreach}

{if $option.link_rewrite}
        $fields['input'][] = array(
            'type' => 'text',
            'label' => $this->l('Friendly URL'),
            'name' => 'link_rewrite',
            'lang' => true,
            'required' => true,
            'hint' => $this->l('Only letters, numbers, underscore (_) and the minus (-) character are allowed.')
        );
{/if}

{if $option.active}
        $fields['input'][] = array(
            'type' => 'radio',
            'label' => $this->l('Active:'),
            'name' => 'active',
            'required' => false,
            'class' => 't',
            'is_bool' => true,
            'values' => array(
                array(
                    'id' => 'active_on',
                    'value' => 1,
                    'label' => $this->l('Enabled')
                ),
                array(
                    'id' => 'active_off',
                    'value' => 0,
                    'label' => $this->l('Disabled')
                )
            ),
            'desc' => $this->l('Allow or disallow display')
        );
{/if}




{if $option.linkable}

        $fields['input'][] = array(
            'type' => 'text',
            'label' => $this->l('Image Alt'),
            'name' => 'image_alt',
            'lang' => true,
        );
        $fields['input'][] = array(
            'type' => 'text',
            'label' => $this->l('Class CSS'),
            'name' => 'css',
            'desc' => $this->l('Add a custum css class on item'),
        );
        $fields['input'][] = array(
            'type' => 'text',
            'label' => $this->l('Mini Tip'),
            'name' => 'minitip',
            'lang' => true,
            'desc' => $this->l('Add a tip on block'),
        );
        $fields['input'][] = array(
            'type' => 'radio',
            'container_class'=>'item_type',
            'class' => 't menu-list',
            'label' => $this->l('Item type'),
            'name' => 'type',
            'values' => MenuHelper::getMenuTypeRadio(true),
            'desc' => $this->l('Choose type of item')
        );
        $fields['input'][] = array(
            'type' => 'radio',
            'class' => 't',
            'container_class'=> 'member item-bool',
            'label' => $this->l('Member only:'),
            'required' => false,
            'name' => 'member_only',
            'desc' => $this->l('Item show only for authentified user'),
            'is_bool' => true,
            'values' => array(
                array(
                    'id' => 'member_only_on',
                    'value' => 1,
                    'label' => $this->l('Enabled')
                ),
                array(
                    'id' => 'member_only_off',
                    'value' => 0,
                    'label' => $this->l('Active ? ')
                )
            ),
        );
        $fields['input'][] = array(
            'type' => 'radio',
            'container_class'=> 'guest item-bool',
            'class' => 't',
            'label' => $this->l('Guest only:'),
            'required' => false,
            'name' => 'guest_only',
            'desc' => $this->l('Item show only for not authentified user'),
            'is_bool' => true,
            'values' => array(
                array(
                    'id' => 'guest_only_on',
                    'value' => 1,
                    'label' => $this->l('Enabled')
                ),
                array(
                    'id' => 'guest_only_off',
                    'value' => 0,
                    'label' => $this->l('Disabled')
                )
            ),
        );
        $fields['input'][] = array(
            'type' => 'radio',
            'container_class'=> 'no-follow item-bool',
            'class' => 't',
            'label' => $this->l('No follow :'),
            'required' => false,
            'name' => 'no_follow',
            'is_bool' => true,
            'desc' => $this->l('SEO information'),
            'values' => array(
                array(
                    'id' => 'no_follow_on',
                    'value' => 1,
                    'label' => $this->l('Enabled')
                ),
                array(
                    'id' => 'no_follow_off',
                    'value' => 0,
                    'label' => $this->l('Disabled')
                )
            ),
        );
        $fields['input'][] = array(
            'type' => 'radio',
            'class' => 't',
            'container_class'=> 'new-window item-bool',
            'label' => $this->l('New window:'),
            'container_class'=> 'new_window item-bool',
            'required' => false,
            'name' => 'new_window',
            'desc' => $this->l('Open link into new window or tabs'),
            'is_bool' => true,
            'values' => array(
                array(
                    'id' => 'new_window_on',
                    'value' => 1,
                    'label' => $this->l('Enabled')
                ),
                array(
                    'id' => 'new_window_off',
                    'value' => 0,
                    'label' => $this->l('Disabled')
                )
            ),
        );
        $fields['input'][] = array(
            'type' => 'radio',
            'class' => 't',
            'label' => $this->l('Lightbox ? :'),
            'container_class'=> 'lightbox item-bool',
            'required' => false,
            'name' => 'lightbox',
            'desc' => $this->l('Open item in Lighbox'),
            'is_bool' => true,
            'values' => array(
                array(
                    'id' => 'lightbox_on',
                    'value' => 1,
                    'label' => $this->l('Enabled')
                ),
                array(
                    'id' => 'lightbox_off',
                    'value' => 0,
                    'label' => $this->l('Disabled')
                )
            ),
        );
{/if}
        $fields['submit'] = array(
            'title' => $this->l('   Save   '),
            'class' => 'button'
        );
        $this->fields_form[] = array('class' => 'global','form' => $fields);
{if $option.linkable}
        $this->fieldsetCategory(false);
        $this->fieldsetCmsCategory(false);
        $this->fieldsetCms();
        $this->fieldsetInternal();
        $this->fieldsetProduct();
        $this->fieldsetManufacturer();
        $this->fieldsetSupplier();
        $this->fieldsetExternal();
        $this->fieldsetAnchor();
        $this->fieldsetAttachment();
        $this->fieldsetLightbox();
{/if}
        $this->toolbar_btn['save-and-stay'] = array(
            'short' => 'SaveAndStay',
            'href' => '#',
            'desc' => $this->l('Save and stay'),
        );

        if($this->isPresta16())
            $this->base_tpl_form  = 'form16.tpl';

        $this->setTemplate('edit.tpl');
        $render_form = parent::renderForm();

        $this->show_toolbar = true;
        $this->context->smarty->assign(array(
            'show_toolbar' => $this->show_toolbar,
            'toolbar_btn' => $this->toolbar_btn,
            'title' => array($this->l('{$entity} Manager'), $this->l('Edit'))
        ));

        $this->content = $render_form;
    }


{foreach $fields as $field}{if isset($field.callback)}
    public static function {$field.callback}{$field.name|ucfirst}(${$field.name}, $param)
    {
{if $field.callback == 'getThumbImage'}

        $path = "{$module_name|lower}/{$entity}/{$field.name}";
        $ext = 'jpg';
        $fileName = $param['id_{$entity}'].'.'.$ext;
        $file = _PS_IMG_ . $path . "/".$fileName;
        $fileRealPath = _PS_IMG_DIR_ . $path . "/".$fileName;

        $image_picture = file_exists($fileRealPath);
        if(!$image_picture)
        {
            $ext = 'png';
            $fileName = $param['id_{$entity}'].'.'.$ext;
            $fileRealPath = _PS_IMG_DIR_ . $path . "/".$fileName;
            $image = file_exists($fileRealPath);
        }


        if(file_exists($fileRealPath))
        {
            $url_image = _PS_BASE_URL_ . PstImage::cacheResize($path, $fileName, 60,60);
            return '<img src="'.$url_image.'" />';
        }
{elseif $field.callback == 'callBackDatetime'}
        return self::displayDateTime('{$field.name}',$param);
{elseif $field.callback == 'callBackColor'}
        return self::displayColor('{$field.name}',$param);
{/if}
    }
{/if}
{/foreach}
}
