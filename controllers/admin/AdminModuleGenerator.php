<?php
/**
 * Created by JetBrains PhpStorm.
 * User: sim
 * Date: 28/11/12
 * Time: 20:17
 * To change this template use File | Settings | File Templates.
 */
class AdminModuleGeneratorController extends PstAdminController
{
    public function __construct(){
        $this->bootstrap = true;
        $this->module_name = 'pstgenerator';

        $this->context = Context::getContext();
        $this->table = 'pst_modulestruct';
        $this->className = 'ModuleStruct';
        $this->identifier = 'id_modulestruct';

        $this->requiredDatabase = false;
        $this->context = Context::getContext();
        $this->bootstrap = true;
        parent::__construct();


        $this->fields_list = array(
            'id_modulestruct' => array(
                'title' => $this->l('ID'),
                'align' => 'center',

                'width' => 25
            ),

            'module_name' => array(
                'title' => $this->l('module_name'),
                'width' => 'auto',
                'required'=>true,
                'lang' => false,
            ),
            'module_display_name' => array(
                'title' => $this->l('module_display_name'),
                'width' => 'auto',
                'required'=>true,
                'lang' => false,
            ),
            'module_description' => array(
                'title' => $this->l('module_description'),
                'width' => 'auto',
                'required'=>true,
                'lang' => false,
            ),

            'position' => array(
                'title' => $this->l('Position'),
                'width' => 40,
                'filter_key' => 'a!position',
                'position' => 'position'
            )
        );
        $this->bulk_actions = array(
            'delete' => array('text' => $this->l('Delete selected'), 'confirm' => $this->l('Delete selected items?')),
            'enableSelection' => array('text' => $this->l('Enable selection')),
            'disableSelection' => array('text' => $this->l('Disable selection'))
        );


        $this->show_toolbar = false;
        $this->multiple_fieldsets = false;

    }




    public function renderList()
    {
        $this->addRowAction('edit');
        $this->addRowAction('delete');

        $this->_orderBy = 'position';


        return parent::renderList();
    }


    public function renderForm()
    {
        $this->context->controller->addJS($this->module_path . 'js/entities.js');
        $this->context->controller->addJS($this->module_path . 'js/configuration.js');
        $this->context->controller->addJS($this->module_path . 'js/hook.js');
        $this->context->controller->addCSS($this->module_path . 'css/entities.css');
        $fields_form = array(
            'form' => array(
                'legend' => array(
                    'title' => $this->l('Module generator'),
                    'icon' => 'icon-cogs'
                ),
                'input' => array(
                    array(
                        'type'=>'text',
                        'label' => $this->l('Module Class Name'),
                        'name' => 'module_name',
                        'desc' => $this->l('Prefix with pst to uniformate Super Tool module'),
                    ),
                    array(
                        'type'=>'text',
                        'label' => $this->l('Module Name'),
                        'name' => 'module_display_name',
                    ),
                    array(
                        'type'=>'text',
                        'label' => $this->l('Module Description'),
                        'name' => 'module_description',
                        'desc' => $this->l('Prefix with pst to uniformate Super Tool module'),
                    ),
                    array(
                        'type'=>'text',
                        'label' => $this->l('Main menu for entities'),
                        'name' => 'main_menu',
                        'desc' => $this->l('if it leave blank it will be Super Tool'),
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->l('Add Empty JS'),
                        'name' => 'has_js',
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
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->l('Add Empty CSS'),
                        'name' => 'has_css',
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
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->l('Add Empty SASS'),
                        'name' => 'has_sass',
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
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->l('Remove DB'),
                        'name' => 'db_uninstall',
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
                        'desc' => $this->l('Removes the database linked before module installation')
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->l('Backup'),
                        'name' => 'backup',
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
                        'desc' => $this->l('Make a backup of your module before create it')
                    ),
                    array(
                        'type' => 'configuration',
                        'label' => $this->l('Module configuration'),
                        'name' => 'configuration',
                        'types_json'=>Tools::jsonEncode(PstGeneratorHelper::getType()),
                        'values'=>array(
                            1,
                            2,
                        ),
                    ),
                    array(
                        'type' => 'entities',
                        'label' => $this->l('Entities'),
                        'name' => 'entities',
                        'types_json'=>Tools::jsonEncode(PstGeneratorHelper::getTypeEntities()),
                        'values'=>array(
                            1,
                            2,
                        ),
                        'boolean_options'=>PstGeneratorHelper::getBooleanOptions(),
                        'boolean_options_json'=>Tools::jsonEncode(PstGeneratorHelper::getBooleanOptions()),
                    ),
                    array(
                        'type' => 'hooks',
                        'label' => $this->l('Hooks'),
                        'name' => 'hooks',
                        'values'=>array(
                            'query'=>PstGeneratorHelper::getHooks(),
                            'id'=>'id_hook',
                            'name' => 'name'
                        )
                    ),
                ),
                'submit' => array(
                    'title' => $this->l('Generate'),
                    'class' => 'btn btn-default pull-right',
                    'icon' => 'icon-AdminAttributeGenerator')
            ),
        );

        $helper = new HelperForm();
        if ($this->object && $this->object->id){
            $helper->id = $this->object->id;
        }
        $helper->show_toolbar = false;
        $lang = new Language((int)Configuration::get('PS_LANG_DEFAULT'));
        $helper->default_form_language = $lang->id;
        $this->fields_form = array();


        $helper->base_folder = $this->module_path . 'template/admin/';
        $helper->base_tpl = 'form.tpl';

        $this->getConfigFieldsValues();

        $helper->fields_value = $this->fields_value;
        $helper->identifier = $this->identifier;
        $helper->submit_action = 'submitGenerate';
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModuleGenerator', false);
        $helper->token = Tools::getAdminTokenLite('AdminModuleGenerator');
        $helper->tpl_vars = array(
            'fields_value' => $this->fields_value,
            'languages' => $this->context->controller->getLanguages(),
            'id_language' => $this->context->language->id
        );

        return $helper->generateForm(array($fields_form));
    }

    public function getHookValues(){
        $hooks = PstGeneratorHelper::getHooks();

        $this->hooks = array();
        $this->hook_list = array('displayHeader'=>array());


        foreach ($hooks as $hook)
        {
            if($this->fields_value['hooks_'.$hook['id_hook']] = (Tools::getValue('hooks_'.$hook['id_hook']) == 'on'))
            {
                $new_hook = new Hook($hook['id_hook']);
                $this->hooks[] = $new_hook;
                $this->hook_list[$new_hook->name] = array(
                    'superblock' => Tools::getValue('hooks_'.$hook['id_hook'] .'_superblock',false),
                    'menu' => Tools::getValue('hooks_'.$hook['id_hook'] .'_menu',false),
                );
            }
        }
        $this->hook_list = Tools::jsonEncode($this->hook_list);
    }
    public function getConfigFieldsValues(){

        $fields = array(
                    'entityDataInput',
                    'configurationDataInput',
                    'module_name',
                    'main_menu',
                    'backup',
                    'has_css',
                    'has_sass',
                    'has_js',
                    'db_uninstall',
                    'module_description',
                    'module_display_name');

        $this->loadObject(true);

        $this->getHookValues();

        if ($this->object && $this->object->id)
        {
            $this->fields_value['form_id'] = $this->object->id;
            foreach($fields as $data_name)
            {
                $this->fields_value[$data_name] = Tools::getValue($data_name,$this->object->{$data_name});
                $this->context->smarty->assign($data_name, $this->fields_value[$data_name]);
            }


            $entities_list = trim(rtrim($this->object->entities_list, '"'),'"');
            $entityDataInput = Tools::jsonDecode(Tools::getValue('entityDataInput',$entities_list), true);
            if(is_array($entityDataInput))
                foreach($entityDataInput  as $entity => $data)
                {
                    $entityDataInput[$entity]['fields'] = PstGeneratorHelper::addType($data['fields']);
                }






            $this->fields_value['entityDataInput'] = Tools::jsonEncode($entityDataInput);
            $this->fields_value['entities'] = Tools::jsonEncode($entityDataInput);


            $configuration_list = trim(rtrim($this->object->configuration_list, '"'),'"');
            $configurationDataInput = Tools::jsonDecode(Tools::getValue('configurationDataInput',$configuration_list), true);
            if(is_array($configurationDataInput))
                foreach($configurationDataInput  as $configuration => $data)
                {
                    $configurationDataInput[$configuration]['fields'] = PstGeneratorHelper::addType($data['fields']);
                }


            $this->fields_value['configurationDataInput'] = Tools::jsonEncode($configurationDataInput);
            $this->fields_value['configuration'] = Tools::jsonEncode($configurationDataInput);


            foreach(Tools::jsonDecode($this->object->hook_list, true) as $hook => $data)
            {
                $hook_id = Hook::getIdByName($hook);
                $this->fields_value['hooks_'.$hook_id] = true;
                $this->fields_value['hooks_'.$hook_id .'_superblock'] = @$data['superblock'];
                $this->fields_value['hooks_'.$hook_id .'_menu']       = @$data['menu'];
            }
        }
        else
        {
            foreach($fields as $data_name)
            {
                $this->fields_value[$data_name] = Tools::getValue($data_name,'');
                $this->context->smarty->assign($data_name, $this->fields_value[$data_name]);
            }
            $this->getHookValues();

            if($this->fields_value['entityDataInput'])
            {
                $entityDataInput = Tools::jsonDecode($this->fields_value['entityDataInput'], true);
                foreach($entityDataInput  as $entity => $data)
                {
                    $entityDataInput[$entity]['fields'] = PstGeneratorHelper::addType($data['fields']);
                }
                $this->fields_value['entityDataInput'] = $entityDataInput;
            }

            if($this->fields_value['configurationDataInput'])
            {
                $configurationDataInput = Tools::jsonDecode($this->fields_value['configurationDataInput'], true);
                foreach($configurationDataInput  as $entity => $data)
                {
                    $configurationDataInput[$entity]['fields'] = PstGeneratorHelper::addType($data['fields']);
                }
                $this->fields_value['configurationDataInput'] = $configurationDataInput;
            }

        }
    }


    public function initContent(){
        if(Tools::isSubmit('submitGenerate'))
        {
            $this->getModuleInstance()->setConfigurationUrl(self::$currentIndex.'&token='.$this->token);
            $this->getConfigFieldsValues();
            if(empty($this->fields_value['module_name']))
            {
                $this->errors['Module name is empty'];
            }
            if(!preg_match('/^[a-zA-Z]{4,30}$/',$this->fields_value['module_name']))
            {
                $this->errors['Name is not valid'];
            }


            if(count($this->errors) == 0)
            {
                if(isset($_POST['generateAndInstall'])){
                    $this->saveToDb();
                    $this->generate();
                    $this->install();
                    $this->displayInformation('Module configuration saved');
                    if(_PS_MODE_DEV_)
                        die('Module generated and install');
                }
                elseif(isset($_POST['saveIntoDb']))
                {
                    $this->saveToDb();
                    $this->displayInformation('Module configuration saved');
                }
                else
                {
                    $this->saveToDb();
                    $this->generate();
                    $this->displayInformation('Module generated');
                    if(_PS_MODE_DEV_)
                        die('Module generated');
                }
                Tools::redirectAdmin(self::$currentIndex.'&token='.Tools::getAdminTokenLite('AdminModuleGenerator'));
            }
        }
        $this->context->smarty->assign(array(
                'has_fixtures'       => Module::isInstalled('pstfixtures'),
                'has_superblock'    => Module::isInstalled('pstsuperblock'),
                'has_menunamager'   => Module::isInstalled('pstmenunamager'),
            ));

        parent::initContent();
    }

    protected function install(){
        PstToolsHelper::cleanCacheLoader();

        $module = Module::getInstanceByName(strtolower($this->fields_value['module_name']));
        if(Module::isInstalled(strtolower($this->fields_value['module_name'])))
        {
            $module->uninstall();
            $module->install();
        }
        else
        {
            if($module)
                $module->install();
            else
            {
                $this->displayInformation("Module can't be instanced");
                if(_PS_MODE_DEV_)
                    die("module can't be instanced");
            }
        }

    }
    /**
     * @desc save module configuration in database
     */
    protected function saveToDb(){
        $this->loadObject();
        if ($this->object && $this->object->id)
        {
            $module = $this->object;
        }
        else
        {
            $module = new ModuleStruct();
        }

        $module->module_name = $this->fields_value['module_name'];
        $module->module_display_name = $this->fields_value['module_display_name'];
        $module->module_description = $this->fields_value['module_description'];
        $module->backup = $this->fields_value['backup'];
        $module->has_js = $this->fields_value['has_js'];
        $module->has_css = $this->fields_value['has_css'];
        $module->has_sass = $this->fields_value['has_sass'];
        $module->db_uninstall = $this->fields_value['db_uninstall'];
        $module->main_menu = $this->fields_value['main_menu'];
        $module->hook_list = $this->hook_list;
        $module->entities_list = Tools::jsonEncode($this->fields_value['entityDataInput']);


        $module->configuration_list = Tools::jsonEncode($this->fields_value['configurationDataInput']);


        $module->save();
    }

    /**
     * @desc generate module
     */
    protected function generate(){
        PstGeneratorHelper::$_moduleName = strtolower($this->fields_value['module_name']);
        $this->new_module_path = _PS_MODULE_DIR_ . strtolower($this->fields_value['module_name']);
        if($this->fields_value['backup'])
        {
            $source = $this->new_module_path;
            $dest = _PS_MODULE_DIR_ . 'pstgenerator/backup/'.time().'_'.strtolower($this->fields_value['module_name']);

            if(!is_dir($dest))
                mkdir($dest, 0777, true);

            if(is_dir($this->new_module_path))
                PstGeneratorHelper::copyr($source, $dest);
        }
        PstGeneratorHelper::rrmdir($this->new_module_path);
        mkdir($this->new_module_path);

        $entities = Tools::jsonDecode($this->fields_value['entityDataInput'], true);
        $has_entities = count($entities)!=0;
        $fixtures = array();
        $configurations = Tools::jsonDecode($this->fields_value['configurationDataInput'], true);

//        foreach($configurations as $fieldset => $data)
//        {
//            foreach($data['field'] as $field_name => $field_data)
//            {
//                $data['field'][$field_name]['type_form'] =
//            }
//        }

        $has_configuration = count($configurations)!=0;
        $this->context->smarty->assign(array(
                'has_entities'      => $has_entities,
                'entities'          => $entities,

                'has_configuration' => $has_configuration,
                'configuration'     => $configurations,
                'configuration_admin_class'     => 'Admin' . $this->fields_value['module_name'] .'Config',
                'module_name'     => $this->fields_value['module_name'],

                'hook_list'         => $this->hook_list,
                'main_menu'         => $this->fields_value['main_menu'],
                'hooks'             => $this->hooks,
            ));


        $hookNoTemplate = array('displayHeader');
        foreach(Tools::jsonDecode($this->hook_list, true) as $hook=>$data)
        {
            if(!in_array($hook, $hookNoTemplate))
                $this->renderAndSaveHookTemplate($hook, $data);
        }

        $list_copy_file = array(
            'logo.gif',
            'logo.png',
        );
        if($this->fields_value['has_js'])
            $list_copy_file[] = 'js';


        if($this->fields_value['has_css'])
            $list_copy_file[] = 'css';

        if($this->fields_value['has_sass'])
            $list_copy_file[] = 'sass';

        if($has_entities)
            $list_copy_file[] = 'views/templates/admin';




        $dbInstall = '';
        $dbUninstall = '';
        $fixture_to_install = '';
        $has_front_detail_rewrite = $has_front_list = false;
        $entites = Tools::jsonDecode($this->fields_value['entityDataInput'], true);
//        $configuration = Tools::jsonDecode($this->fields_value['configurationDataInput'], true);



        foreach($entites as $entity => $data)
        {
            $many_entities = array();
            $has_fixtures = $has_many = $has_image = $is_multi_lang = false;
            foreach($data['fields'] as $field)
            {
                if($field['type'] == 'image' || $field['type'] == 'image_ml')
                    $has_image = true;

                if($field['type'] == 'many_entity')
                {
                    $many_entities[] = $field['entity'];
                    $has_many = true;
                }

                if($field['is_multi_lang'])
                    $is_multi_lang = true;
            }


            $options = array();
            foreach($data['options'] as $key=> $option)
            {
                $options[$key] = $option;
            }




            if(Module::isInstalled('pstfixtures') && $options['find_fixture'])
            {
                $fixtures[$entity] = FixturesHelper::findFixture($entity);
                $has_fixtures = $entity;
            }

            $main_menu_class = PstToolsHelper::cleaner(str_replace(' ','',$this->fields_value['main_menu']));

            $front_name = $data['front_name'];
            if(empty($front_name))
                $front_name = $entity;

            $lower_entity = strtolower($entity);


            $this->context->smarty->assign(array(
                    'option'            => $options,
                    'has_image'         => $has_image,
                    'imagePath'         => _PS_IMG_DIR_ .strtolower($this->fields_value['module_name']).DS. strtolower($entity),
                    'imageWebPath'      => strtolower($this->fields_value['module_name']).DS. strtolower($entity),
                    'has_many'          => $has_many,
                    'has_fixtures'      => $has_fixtures,
                    'is_multi_lang'     => $is_multi_lang,
                    'fields'            => $data['fields'],
                    'entity_model'      => $entity,
                    'main_menu_class'   => $main_menu_class,
                    'front_name'        => $front_name,
                    'entity'            => $lower_entity,
                    'front_controller_list'     =>$options['front_controller_list'],
                    'front_controller_detail'   =>$options['front_controller_detail']
                ));


            if($options['front_controller_list']){
                $has_front_list = true;
                $this->renderAndSaveFrontTemplate('list',$entity, $data);
                $this->renderAndSaveClass('PstFrontEntityList.php', strtolower($entity).'list', 'controllers/front');
            }

            if($options['front_controller_detail']){
                $has_front_detail_rewrite = isset($data['options']['link_rewrite']);
                $this->renderAndSaveFrontTemplate('detail',$entity, $data);
                $this->renderAndSaveClass('PstFrontEntityDetail.php', strtolower($entity).'detail', 'controllers/front');
            }


            $this->renderAndSaveClass('Entity.php', $entity);
            $this->renderAndSaveClass('AdminEntities.php', 'Admin'.$entity, 'controllers/admin');

            ob_start();
            $this->context->smarty->display(_PS_MODULE_DIR_ . $this->module_name . '/render/db.tpl');
            $dbInstall .= ob_get_contents();
            ob_clean();

            if($has_fixtures)
                $fixture_to_install .= "\t\tDb".$this->fields_value['module_name']."Helper::import".$has_fixtures."Fixture();\n";

            $dbUninstall .= "\t\tDb::getInstance()->Execute('DROP TABLE IF EXISTS '._DB_PREFIX_.'pst_".$lower_entity."');\n";
            if($is_multi_lang)
                $dbUninstall .= "\t\tDb::getInstance()->Execute('DROP TABLE IF EXISTS '._DB_PREFIX_.'pst_".$lower_entity."_lang');\n";
            if($has_many)
            {
                foreach($many_entities as $many)
                    $dbUninstall .= "\t\tDb::getInstance()->Execute('DROP TABLE IF EXISTS '._DB_PREFIX_.'pst_".$lower_entity.'_'.strtolower($many)."');\n";
            }
        }
        if($has_front_list)
            $list_copy_file[] = 'views/includes';

        $this->copy($list_copy_file);

        if($fixture_to_install != '')
        {
            $dbInstall .= "\t\t/*
         *  Load Fixtures (Sample data)
         */\n";
            $dbInstall .= $fixture_to_install;
        }
        $this->context->smarty->assign(array('fixtures'=>$fixtures));
        $this->renderAndSaveClass('DbHelper.php', 'Db'.$this->fields_value['module_name'].'Helper');

        if($has_front_detail_rewrite)
            $this->renderAndSaveClass('Link.php', $this->fields_value['module_name'].'Link');

        if($has_configuration)
        {
            $this->renderAndSaveClass('AdminConfig.php', 'Admin' . $this->fields_value['module_name'] .'Config', 'controllers/admin');
        }


        $this->context->smarty->assign(array(
                'dbInstall'=>$dbInstall,
                'has_header'=> $this->fields_value['has_js'] || $this->fields_value['has_css'] || $this->fields_value['has_sass'],
                'has_js'=>$this->fields_value['has_js'],
                'has_css'=>$this->fields_value['has_css'],
                'has_sass'=>$this->fields_value['has_sass'],
                'db_uninstall' => $this->fields_value['db_uninstall'],
                'dbUninstall'=>$dbUninstall,
                'has_front_detail_rewrite'=>$has_front_detail_rewrite
        ));
        $this->renderAndSaveTemplate('pstmodule.php');
    }

    /**
     * @desc copy a list of file in new module
     * @param $list
     */
    protected function copy($list){
        $path =  _PS_MODULE_DIR_ . $this->module_name .'/template/pstmodule/';
        foreach($list as $file)
        {
            if(is_dir($path . $file))
                PstGeneratorHelper::copyr($path . $file, $this->new_module_path.DS. $file);
            else
                copy($path . $file, $this->new_module_path.DS. $file);
        }
    }

    /**
     * @desc render class template in new module
     * @param $template
     * @param $fileName
     * @param string $dir
     */
    protected function renderAndSaveClass($template, $fileName, $dir='libs/classes'){
        $this->ext  = '.tpl';
        $rootPath = _PS_MODULE_DIR_ . $this->module_name . '/template/pstmodule/' .$dir . DS;
        $templatePath =  $rootPath . $template. $this->ext;


        if(is_file($templatePath)){
            ob_start();
            $this->context->smarty->display($templatePath);
            $content = ob_get_contents();
            ob_clean();
            if(!is_dir($this->new_module_path.DS .$dir. DS))
            {
                mkdir($this->new_module_path.DS .$dir. DS, 0777, true);
            }
            file_put_contents($this->new_module_path.DS .$dir. DS.$fileName . '.php', $content);
        }
    }
    /**
     * @desc render template in new module
     * @param $template
     */
    protected function renderAndSaveFrontTemplate($controller, $entityName, $data){
        if(!in_array($controller, array('detail','list')))
            throw new PrestaShopException('controller type is not defined');

        $this->ext  = '.tpl';

        if(!is_dir($this->new_module_path.DS.'views/templates/front'))
        {
            mkdir($this->new_module_path.DS.'views/templates/front', 0777, true);
        }

        $this->context->smarty->assign(array('data' => $data, 'entityName'=>$entityName));

        $templatePath = _PS_MODULE_DIR_ . $this->module_name . '/template/pstmodule/views/templates/front/' . $controller. $this->ext;

        if(is_file($templatePath)){
            ob_start();
            $this->context->smarty->display($templatePath);
            $content = ob_get_contents();
            echo $content;
            ob_clean();


            file_put_contents($this->new_module_path.DS.'views/templates/front'.DS. strtolower($entityName) . '_' . $controller.$this->ext, $content);
        }
    }
    /**
     * @desc render template in new module
     * @param $template
     */
    protected function renderAndSaveHookTemplate($hook, $data){
        $template = 'hook.tpl';
        $this->ext  = '.tpl';

        if(!is_dir($this->new_module_path.DS.'hook'))
        {
            mkdir($this->new_module_path.DS.'hook');
        }
        $data['superblock'] = PstToolsHelper::namer($data['superblock']);
        $data['menu'] = PstToolsHelper::namer($data['menu']);

        $this->context->smarty->assign($data);
        $templatePath = _PS_MODULE_DIR_ . $this->module_name . '/template/pstmodule/hook/' . $template. $this->ext;
        if(is_file($templatePath)){
            ob_start();
            $this->context->smarty->display($templatePath);
            $content = ob_get_contents();
            echo $content;
            ob_clean();
            file_put_contents($this->new_module_path.DS.'hook'.DS.str_replace('hook', strtolower($hook), $template), $content);
        }
    }
    /**
     * @desc render template in new module
     * @param $template
     */
    protected function renderAndSaveTemplate($template)
    {
        $this->ext  = '.tpl';
        $templatePath = _PS_MODULE_DIR_ . $this->module_name . '/template/pstmodule/' . $template. $this->ext;
        if(is_file($templatePath)){
            ob_start();
            $this->context->smarty->display($templatePath);
            $content = ob_get_contents();
            echo $content;
            ob_clean();
            file_put_contents($this->new_module_path.DS . str_replace('pstmodule', strtolower($this->fields_value['module_name']), $template), $content);
        }
    }

}
