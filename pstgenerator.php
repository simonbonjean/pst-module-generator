<?php

if (!defined('_PS_VERSION_'))
    exit;

class PstGenerator extends PstModule {
    protected $_config = array();

    public function __construct()
    {
        $this->name = 'pstgenerator';
        $this->tab = 'front_office_features';
        $this->version = '1.0.3';

        $this->_admin_class = "AdminModuleGenerator";
        parent::__construct();
        $this->description = $this->l('Generate empty module.');


        $this->page = basename(__FILE__, '.php');
        $this->displayName = $this->l('Module Generator');
    }
    public function install(){

        $this->installDb();

        parent::install();
        PstToolsHelper::cleanCacheLoader();
    }

    public function installDb(){
        /*
         *  SQL installation for ModuleStruct Model
         */

        $query = 'CREATE TABLE IF NOT EXISTS '._DB_PREFIX_.'pst_modulestruct (
              `id_modulestruct` int(10) NOT NULL AUTO_INCREMENT,
              `module_name` varchar(255) NOT NULL,
              `module_display_name` varchar(255) NOT NULL,
              `module_description` varchar(255) NOT NULL,
              `backup` tinyint(1) unsigned NOT NULL DEFAULT 0,
              `has_js` tinyint(1) unsigned NOT NULL DEFAULT 1,
              `has_css` tinyint(1) unsigned NOT NULL DEFAULT 1,
              `has_sass` tinyint(1) unsigned NOT NULL DEFAULT 1,
              `db_uninstall` tinyint(1) unsigned NOT NULL DEFAULT 0,
              `main_menu` varchar(255) NOT NULL,
              `hook_list` text NOT NULL,
              `entities_list` text NOT NULL,
              `configuration_list` text NOT NULL,
              `date_add` datetime NOT NULL,
              `date_upd` datetime NOT NULL,
              `position` int(10) unsigned NOT NULL DEFAULT 0,
            PRIMARY KEY(`id_modulestruct`)
            ) ENGINE=MyISAM default CHARSET=utf8';

        if (!Db::getInstance()->Execute($query))
            return false;

    }
}