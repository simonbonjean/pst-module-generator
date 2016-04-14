<?php

if (!defined('_PS_VERSION_'))
    exit;


if (!class_exists('PstModule', true))
{
    include _PS_MODULE_DIR_. 'pst/autoload_patcher.php';
}

class {$module_name} extends PstModule {
{if !$has_configuration}
    protected $_config = array(
        'general' => array()
    );
{else}
protected $_config = array(
{foreach from=$configuration key=fieldset item=data}
    '{$fieldset|strtolower}'=> array(
    'label'=>'{$fieldset}',
    {if isset($data.desc)}        'desc'=> '{$data.desc}',{/if}
    'fields'=>array(
    {foreach from=$data.configFields key=field_name item=field_data}
        'PST_{$module_name|strtoupper}_{$fieldset|strtoupper}_{$field_name|strtoupper}'=> array(
        'type'=>'{$field_data.type}',
        'default_value'=>'',
        'label'=>'{$field_data.name|replace:'_':' '|ucfirst}',
        {if isset($field_data.desc) && !empty($field_data.desc)}                    'desc'=>'{$field_data.desc}',{/if}

        ),
    {/foreach}
    )
    ),
{/foreach}
);
{/if}

    protected $_hook_list = array({foreach $hooks as $hook}'{$hook->name}',{/foreach}{if $has_header}'displayHeader', {/if}{if $has_front_detail_rewrite}'ModuleRoutes', {/if});

    public function __construct()
    {
        $this->name = '{$module_name|lower}';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';

        parent::__construct();
        $this->description = $this->l('{$module_description}');
        $this->page = basename(__FILE__, '.php');
        $this->displayName = $this->l('{$module_display_name}');
{if $db_uninstall}
        $this->_drop_db = true;
{/if}
    }

    public function install()
    {
{if $has_front_detail_rewrite}
        $this->createHook('ModuleRoutes');
{/if}
{if $has_configuration || !empty($main_menu)}
        $this->installTab('Admin{$module_name}Config', "{$main_menu}", self::TAB_DEFAULT_ROOT);
{/if}

{if $has_entities}
        $this->installDb();
{foreach from=$entities key=entity item=data}

        /** Entity : {$entity} */
{if $data.options.front_controller_list}
        $this->installMeta('{$entity}', '{$entity|lower}', '{if isset($data.front_name) && !empty($data.front_name)}{$data.front_name}{else}{$entity}{/if} List' ,'', '{$entity|lower}list');
{/if}
{if !empty($main_menu)}
        $this->installTab('Admin{$entity}', "{if isset($data.front_name) && !empty($data.front_name)}{$data.front_name}{else}{$entity}{/if}","Admin{$module_name}Config");
{else}
        $this->installTab('Admin{$entity}', "{if isset($data.front_name) && !empty($data.front_name)}{$data.front_name}{else}{$entity}{/if}");
{/if}
{assign var=fields value=$data.fields}
{foreach from=$fields key=field item=data}
{if $data.type == 'image'}
        $this->createImgDirectory('{$module_name|strtolower}/{$entity}/{$field}');
{/if}
{/foreach}
{/foreach}
{/if}
        parent::install();
        PstToolsHelper::cleanCacheLoader();
    }

    public function uninstall()
    {
{if $has_entities}
{foreach from=$entities key=entity item=data}

        /** Entity : {$entity} */
{if $data.options.front_controller_list}
        $this->removeMeta('{$entity|lower}list');
{/if}
        $this->uninstallTab('Admin{$entity}');
{/foreach}
{/if}
{if !empty($main_menu)}
        $this->uninstallTab('Admin{$module_name}Config');
{/if}
        if($this->_drop_db)
        {
            $this->uninstallDb();
        }
        parent::uninstall();
    }

{if $has_header}
    public function hookHeader($params){
{if $has_js}
        $this->context->controller->addJS($this->_path . 'js/{$module_name|strtolower}.js');
{/if}
{if $has_css}
        $this->context->controller->addCSS($this->_path . 'css/{$module_name|strtolower}.css');
{/if}
{if $has_sass}
        $this->context->controller->addCSS($this->_path . 'css/{$module_name|strtolower}.css');
{/if}
    }
{/if}

{foreach $hooks as $hook}
    public function hook{$hook->name|ucfirst}($params){
        $templateName = '{$hook->name|lower}';
        $smartyCacheId = $this->getCacheKey($templateName);
        if (!$this->isCached('hook/'.$templateName. '.tpl', $smartyCacheId))
        {
            // @TODO implement logic
        }
        $this->setLifetime(self::LIFETIME_HOUR);
        $display = $this->display(__FILE__,'hook/'.$templateName . '.tpl', $smartyCacheId);
        return $display;
    }
{/foreach}

{if $has_configuration}
    public function getContent()
    {
        header('Location: index.php?controller={$configuration_admin_class}&token='.md5(pSQL(_COOKIE_KEY_.'{$configuration_admin_class}'.(int)Tab::getIdFromClassName('{$configuration_admin_class}').(int)$this->context->employee->id)));
        exit;
    }
{/if}
{if $has_entities}
    public function uninstallDb(){
{$dbUninstall}
    }
    public function installDb(){
{$dbInstall}
    }
{/if}

{if $has_front_detail_rewrite}
    public function hookModuleRoutes()
    {
        $routes =array();
{foreach from=$entities key=entity item=data}
{if $data.options.front_controller_detail && $data.options.link_rewrite}
        $routes['module-{$module_name|lower}-{$entity|lower}detail'] = array(
            'controller' => '{$entity|lower}detail',
            'rule' =>  '{$entity|lower}-detail/{ldelim}id{rdelim}-{ldelim}link_rewrite{rdelim}',
            'keywords' => array(
                'id'                => array('regexp' => '[\d]+', 'param' => 'id'),
                'link_rewrite'      => array('regexp' => '[\w]+', 'param' => 'link_rewrite'),
            ),
            'params' => array(
                'fc' => 'module',
                'module' => '{$module_name|lower}',
                'controller' => '{$entity|lower}detail'
            )
        );
{/if}
{/foreach}

        return $routes;
    }
{/if}


}