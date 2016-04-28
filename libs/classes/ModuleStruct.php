<?php
/**
 * Created by Produweb
 * User: Simon Bonjean
 * Date: 21/06/13
 * Time: 12:38
 */

class ModuleStructCore extends ObjectModel{

    public $id;

    /** @var string  */
    public $module_name;
    /** @var string  */
    public $module_display_name;
    /** @var string  */
    public $module_description;
    /** @var string  */
    public $hook_list;
    /** @var string  */
    public $entities_list;
    public $configuration_list;
    /** @var bool */
    public $has_entities;
    /** @var string  */
    public $entityDataInput;
    public $configurationDataInput;
    /** @var string  */
    public $main_menu;
    /** @var bool */
    public $backup;
    /** @var bool */
    public $has_css;
    public $has_sass;
    /** @var bool */
    public $has_js;
    public $db_uninstall;

    /** @var string Object creation date */
    public $date_add;
    /** @var string Object last modification date */
    public $date_upd;
    /** @var integer position */
    public $position;

    public static $definition = array(
        'table' => 'pst_modulestruct',
        'primary' => 'id_modulestruct',
        'fields' => array(
            // Lang fields

            'module_name'           => array('type' => self::TYPE_STRING, 'lang' => false,'validate' => 'isString','required'=>true,'size' => 255),
            'module_display_name'   => array('type' => self::TYPE_STRING, 'lang' => false,'validate' => 'isString','required'=>true,'size' => 255),
            'module_description'    => array('type' => self::TYPE_STRING, 'lang' => false,'validate' => 'isString','required'=>false,'size' => 255),
            'main_menu'             => array('type' => self::TYPE_STRING, 'lang' => false,'validate' => 'isString','required'=>false,'size' => 255),
            'backup'                => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'has_css'               => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'has_sass'              => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'has_js'                => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'db_uninstall'          => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'hook_list'             => array('type' => self::TYPE_HTML, 'lang' => false,'validate' => 'isString','required'=>false),
            'entities_list'         => array('type' => self::TYPE_HTML, 'lang' => false,'required'=>false),
            'configuration_list'    => array('type' => self::TYPE_HTML, 'lang' => false,'required'=>false),
            'date_add'              => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
            'date_upd'              => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),

        )
    );


}