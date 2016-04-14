<?php
/**
 * Created by Produweb
 * User: Simon Bonjean
 * Date: 13/09/13
 * Time: 11:34
 */

class PstGeneratorHelperCore extends Helper{
    public static $_moduleName = null;
    public static function copyr($source, $destination)
    {
        if (is_file($source))
        {
            if(!is_null(self::$_moduleName))
                $destination = str_replace('pstmodule', self::$_moduleName, $destination);
            return copy($source, $destination);
        }
        if (!is_dir($destination))
            mkdir($destination, 0777, true);
        $dir = dir($source);
        while (false !== $entry = $dir->read()) {
            if ($entry == '.' || $entry == '..')
                continue;
            if ($destination !== "$source/$entry")
                self::copyr("$source/$entry", "$destination/$entry");
        }
        $dir->close();
        return true;
    }


    public static function rrmdir($dir) {
        if (is_dir($dir)) {
            $objects = scandir($dir);
            foreach ($objects as $object) {
                if ($object != "." && $object != "..") {
                    if (filetype($dir."/".$object) == "dir")
                        self::rrmdir($dir."/".$object);
                    else
                        unlink($dir."/".$object);
                }
            }
            reset($objects);
            rmdir($dir);
        }
    }

    public static function run(){

    }
    /**
     * Return Hooks List
     *
     * @param bool $position
     * @return array Hooks List
     */
    public static function getHooks($position = false)
    {
        $exclude_hook = array(
            'displayAttributeForm',
            'displayAttributeGroupForm',
            'displayAttributeGroupPostProcess',
            'displayBanner',
            'displayBeforeCarrier',
            'displayBeforePayment',
            'displayCarrierList',
            'displayCompareExtraInformation',
            'displayCustomerAccount',
            'displayCustomerAccountForm',
            'displayCustomerAccountFormTop',
            'displayCustomerIdentityForm',
            'displayFeatureForm',
            'displayFeaturePostProcess',
            'displayFeatureValueForm',
            'displayFeatureValuePostProcess',
            'displayMobileTopSiteMap',
            'displayMyAccountBlock',
            'displayMyAccountBlockfooter',
            'displayOrderConfirmation',
            'displayOrderDetail',
            'displayOverrideTemplate',
            'displayPayment',
            'displayPaymentReturn',
            'displayPaymentTop',
            'displayPDFInvoice',
            'displayProductButtons',
            'displayProductComparison',
            'displayProductListFunctionalButtons',
            'displayProductListReviews',
        );


        $hook_list =  Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS('
			SELECT * FROM `'._DB_PREFIX_.'hook` h
			'.($position ? 'WHERE h.`position` = 1' : '').'
			WHERE name like "display%" and name not like "displayAdmin%" and name not like "displayBackOffice%"
			ORDER BY `name`'
        );
        $output = array();
        foreach($hook_list as $hook)
        {
            $hook_name = $hook['name'];
            if(!in_array($hook_name, $exclude_hook))
                $output[] = $hook;
        }
        return $output;
    }

    public static function addType($fields){
        $type = self::getTypeEntities();
        $output_fields = array();
        foreach($fields as $field_name => $info)
        {
            if(!isset($type[$info['type']]))
                continue;
            $dataToAdd = $type[$info['type']];
            foreach($dataToAdd as $key => $data)
            {
                $info[$key] = $data;
            }
            $output_fields[$field_name] = $info;
        }
        return $output_fields;
    }

    public static function getBooleanOptions(){
        $options = array(
            'link_rewrite'              =>array('value'=>false, 'title'=>'Link Rewrite'),
            'linkable'                  =>array('value'=>true, 'title'=>'Linkable'),
            'date_upd'                  =>array('value'=>true, 'title'=>'Date update'),
            'date_add'                  =>array('value'=>true, 'title'=>'Date add'),
            'active'                    =>array('value'=>true, 'title'=>'Active'),
            'find_fixture'              =>array('value'=>true, 'title'=>'Try to find fixtures'),
            'sortable_flat'             =>array('value'=>true, 'title'=>'Sortable'),
            'sortable_nested'           =>array('value'=>true, 'title'=>'Nested'),
            'front_controller_list'     =>array('value'=>true, 'title'=>'Front List'),
            'front_controller_detail'   =>array('value'=>true, 'title'=>'Front Detail')
        );

        return $options;
    }
    public static function getTypeConfiguration(){
        $output = self::getType();

//        $output['id_entity'] = array(
//            'form_type'=>'select',
//            'const_type'=>'TYPE_INT',
//            'is_multi_lang' => false,
//            'is_bool' => true,
//            'type_php'=>'int',
//            'dbDesc'=>'int(10) unsigned NOT NULL DEFAULT 0',
//            'validate' => 'isUnsignedInt',
//        );
        return $output;
    }
    public static function getTypeEntities(){
        $output = self::getType();

        $output['id_entity'] = array(
            'form_type'=>'select',
            'const_type'=>'TYPE_INT',
            'is_multi_lang' => false,
            'is_bool' => true,
            'type_php'=>'int',
            'dbDesc'=>'int(10) unsigned NOT NULL DEFAULT 0',
            'validate' => 'isUnsignedInt',
        );
        $output['many_entity'] = array(
            'form_type'=>'many',
            'const_type'=>'TYPE_INT',
            'is_multi_lang' => false,
            'is_bool' => true,
            'type_php'=>'int',
            'dbDesc'=>false,
            'validate' => 'isUnsignedInt',
        );
        $output['id_entity_full'] = array(
            'form_type'=>'select',
            'const_type'=>'TYPE_INT',
            'is_multi_lang' => false,
            'is_bool' => true,
            'type_php'=>'int',
            'dbDesc'=>'int(10) unsigned NOT NULL DEFAULT 0',
            'validate' => 'isUnsignedInt',
        );
        return $output;
    }
    public static function getType(){
        return PstToolsHelperCore::getType();
    }
}