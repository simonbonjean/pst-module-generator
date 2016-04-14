<?php
/**
 * User: Simon Bonjean
 * Date: 29/11/12
 * Time: 16:23
 */
class {$module_name}{$entity_model}DetailModuleFrontController extends ModuleFrontController
{
    public function __construct()
    {
        parent::__construct();
        $this->context = Context::getContext();
    }
    public function initContent(){

        parent::initContent();

        $id = Tools::getValue('id', false);
        if(!$id)
        {
            // 404
        }

        $element = new {$entity_model}($id, $this->context->language->id);

        $this->context->smarty->assign(array(
            'element' => $element
        ));

        $this->setTemplate('{$entity}_detail.tpl');
    }
}
