<?php
/**
 * User: Simon Bonjean
 * Date: 29/11/12
 * Time: 16:23
 */
class {$module_name}{$entity_model}ListModuleFrontController extends ModuleFrontController
{
    public $elements = null;
    public $nbElement = 0;

    public function __construct()
    {
        parent::__construct();

        $this->context = Context::getContext();

        $protocol_link = (Configuration::get('PS_SSL_ENABLED') || Tools::usingSecureMode()) ? 'https://' : 'http://';
		$useSSL = ((isset($this->ssl) && $this->ssl && Configuration::get('PS_SSL_ENABLED')) || Tools::usingSecureMode()) ? true : false;
        $protocol_content = ($useSSL) ? 'https://' : 'http://';
{if $front_controller_detail}
        $link = new {$module_name}Link($protocol_link, $protocol_content);
        $this->context->module_link = $link;
        $this->context->smarty->assign(array('module_link' => $link));
{/if}

    }
    public function elementSort()
    {
        $order_by_default = 0;
        $order_way_default = 0;
        $order_by_values = array();
{if $option.sortable_nested || $option.sortable_flat}
        $order_by_values[] = 'position';
{elseif $option.date_add}
        $order_by_values[] = 'date_add';
{elseif $option.date_upd}
        $order_by_values[] = 'date_upd';
{/if}
        $order_way_values = array(0 => 'asc', 1 => 'desc');

        $this->orderBy = Tools::strtolower(Tools::getValue('orderby', $order_by_values[$order_by_default]));
        $this->orderWay = Tools::strtolower(Tools::getValue('orderway', $order_way_values[$order_way_default]));

        if (!in_array($this->orderBy, $order_by_values))
            $this->orderBy = $order_by_values[0];
        if (!in_array($this->orderWay, $order_way_values))
            $this->orderWay = $order_way_values[0];

        $this->context->smarty->assign(array(
            'orderby' => $this->orderBy,
            'orderway' => $this->orderWay,
            'orderbydefault' => $order_by_values[$order_by_default],
            'orderwaydefault' => $order_way_values[$order_way_default]
        ));
    }

    public function initContent(){

        parent::initContent();
        $this->elementSort();
        $this->nbElement = {$entity_model}::getElements($this->context->language->id, null, null, null, null, true);

        $this->pagination((int)$this->nbElement);

        $this->elements = {$entity_model}::getElements($this->context->language->id, (int)$this->p, (int)$this->n, $this->orderBy, $this->orderWay);

        $this->context->smarty->assign(array(
            'elements' =>$this->elements,
            'module_tpl_dir' => _PS_MODULE_DIR_.$this->module->name .DS .'views' .DS . 'includes'
        ));
        $this->setTemplate('{$entity|lower}_list.tpl');
    }
}
