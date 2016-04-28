<?php
/**
 * User: Simon Bonjean
 * Date: 21/06/13
 * Time: 12:38
 */

class {$entity_model}Core extends {if $sortable_flat}PstFlatSortObjectModel{else}ObjectModel{/if}{

    public $id;

{foreach $fields as $field}    /** @var {$field.type_php} {$field.desc} */
    public ${$field.name};
{/foreach}



{if $option.linkable}
    /** @var string Type of Element */
    public $type;

    /** @var string Url */
    public $external;
    public $anchor;
    public $has_anchor = false;

    /** @var string css */
    public $css;

    /** @var bool css */
    public $new_window;
    public $member_only = false;
    public $guest_only = false;
    public $no_follow = false;
    public $display_prod_cat_childs = true;
    public $display_cms_cat_childs = true;

    /** @var array Childrens */
    public $childrens;

    public $lightbox = false;
    public $lightbox_width = 200;
    public $lightbox_height = 200;

    public $id_cms;
    public $id_meta;
    public $id_category;
    public $id_cms_category;
    public $id_manufacturer;
    public $id_product;
    public $id_attachment;
    public $id_supplier;

{/if}

{if $option.link_rewrite}    /** @var string unique text */
    public $link_rewrite;
{/if}
{if $option.date_add}    /** @var string Object creation date */
    public $date_add;
{/if}
{if $option.date_upd}    /** @var string Object last modification date */
    public $date_upd;
{/if}
{if $option.sortable_flat}    /** @var integer position */
    public $position;
{/if}
{if $option.sortable_nested}
    /** @var integer Parent category ID */
    public $id_parent;
    /** @var integer Parents number */
    public $level_depth;
    /** @var integer Nested tree model "left" value */
    public $nleft;
    /** @var integer Nested tree model "right" value */
    public $nright;
{/if}
{if $option.active}    /** @var boolean Status for display */
    public $active = true;
{/if}

    public static $definition = array(
        'table' => 'pst_{$entity}',
        'primary' => 'id_{$entity}',
        'multilang' => {if $is_multi_lang}true{else}false{/if},
        'fields' => array(
            // Lang fields

{foreach from=$fields item=field name=fieldLoop}{if $field.form_type != 'file' && $field.type != 'many_entity'}
            '{$field.name}' => array('type' => self::{$field.const_type}, 'lang' => {if $field.is_multi_lang}true{else}false{/if},'validate' => '{$field.validate}'{if isset($field.required) && $field.required == true},'required'=>true{/if}{if isset($field.size)},'size' => {$field.size}{/if}),
{/if}{/foreach}
{if $option.link_rewrite}
            'link_rewrite' => array('type' => self::TYPE_STRING, 'lang' => true, 'validate' => 'isLinkRewrite', 'required' => true, 'size' => 128),
{/if}
{if $option.date_add}
            'date_add' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
{/if}
{if $option.date_upd}
            'date_upd' => array('type' => self::TYPE_DATE, 'validate' => 'isDate'),
{/if}
{if $option.active}
            'active' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
{/if}
{if $option.sortable_flat}
            'position' => 	array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
{/if}
{if $option.sortable_nested}
            'id_parent' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'nleft' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'nright'    => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'position'      => array('type' => self::TYPE_INT),
            'level_depth'   => array('type' => self::TYPE_INT),
{/if}
{if $option.linkable}
            'type' => array('type' => self::TYPE_STRING,'lang' => false, 'validate' => 'isString', 'size' => 64),
            'id_cms' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_product' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_attachment' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_meta' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_category' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_cms_category' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_manufacturer' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),
            'id_supplier' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'),

            'css' => array('type' => self::TYPE_STRING, 'validate' => 'isString'),
            'new_window' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),

            'member_only' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool','default'=>false),
            'guest_only' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool','default'=>false),
            'no_follow' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool','default'=>false),
            'lightbox' => array('type' => self::TYPE_BOOL, 'validate' => 'isBool'),
            'lightbox_width' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt','default'=>200),
            'lightbox_height' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedInt','default'=>200),
{/if}
        )
    );


{if $has_image}
    protected $image_list = array({foreach $fields as $field}{if $field.type == 'image'}'{$field.name}',{/if}{/foreach});
{/if}
    public function __construct($id = null, $id_lang = null, $id_shop = null)
    {
        parent::__construct($id, $id_lang, $id_shop);
{if $has_image}
        $this->image_dir = _PS_IMG_DIR_.'{$module_name}/{$entity|strtolower}/';
        $this->image_web_dir = _PS_IMG_.'{$module_name}/{$entity|strtolower}/';
        $this->getImages();
{foreach $fields as $field}{if $field.type == 'image' || $field.type == 'image'}
        if(file_exists('{$imagePath}/{$field.name}/'.$this->id .'.jpg'))
        {
            $this->{$field.name} =  $this->id .'.jpg';
            $this->{$field.name}_path = '{$imageWebPath}/{$field.name}/';
        }
{/if}{/foreach}
{/if}

    }
    /**
     * Name of entity
     * @return string
     */
    public static function getTitle(){
        if(isset(self::$definition['fields']['name']))
            return 'name';
        if(isset(self::$definition['fields']['title']))
            return 'title';
    }
    /**
     * return true if model is nested set.
     * @return bool
     */
    public static function isTree(){
        return {if $option.sortable_nested}true{else}false{/if};
    }
{if $option.sortable_nested}
    public static function recurseManyTree($items, $field_name ,$checked = array())
    {
        $html ='';
        foreach ($items as $item)
        {
            $html .= '<div class="checkbox">';
            $html .= '<label for="'.$field_name . '_' .$item['id'].'">';
            $html .= '<input type="checkbox" id="'.$field_name . '_' .$item['id'].'" name="'.$field_name . '_' .$item['id'].'"'.((isset($checked[$item['id']])) ? ' checked="checked"' : '').'>';
            $html .= isset($item['level_depth'])?(str_repeat('&nbsp;', $item['level_depth'] * 5)):'';
            $html .= stripslashes($item['value']);
            $html .= '</label>';
            $html .= '</div>';
        }
        return $html;
    }

    public static function recurseTree($items, $id_selected = 1)
    {
        $html ='';
        foreach ($items as $item)
        {
            $html .= '<option value="'.$item['id'].'"'.(($id_selected == $item['id']) ? ' selected="selected"' : '').'>';
            $html .= isset($item['level_depth'])?(str_repeat('&nbsp;', $item['level_depth'] * 5)):'';
            $html .= stripslashes($item['value']).'</option>';
        }
        return $html;
    }
{/if}

    /**
     * Retrieves all elements from database
     * @param null $id_lang
     * @param bool|false $p
     * @param bool|false $n
     * @param null $order_by
     * @param null $order_way
     * @param bool|false $get_total
     * @return array
     */
    public static function getElements($id_lang=null, $p=false, $n=false, $order_by = null, $order_way = null, $get_total = false){
        $where = array();
        {if $option.active}
            $where[] = 'active = true';
        {/if}

        if(empty($where))
            $where = '';
        else
            $where = ' WHERE ' . join($where, ' AND ');

        if($get_total)
            return (int)Db::getInstance(_PS_USE_SQL_SLAVE_)->getValue('SELECT count(id_{$entity}) as total FROM '._DB_PREFIX_.'pst_{$entity}' . $where);

        if(is_null($id_lang))
            $id_lang = Context::getContext()->language->id;

        $join = $title = $limit = "";




{if $is_multi_lang}
        $title ="al.*";
        $join = ' LEFT JOIN '._DB_PREFIX_.'pst_{$entity}_lang al on (a.id_{$entity} = al.id_{$entity} AND al.id_lang = '.(int)$id_lang.')';
{/if}

        if (empty($order_by))
            $order_by = '{if $option.sortable_nested || $option.sortable}position{else}id_{$entity}{/if}';

        if (empty($order_way))
            $order_way = 'ASC';

        $order_by_prefix = 'a';
        $order = ' ORDER BY '.(!empty($order_by_prefix) ? $order_by_prefix.'.' : '').'`'.bqSQL($order_by).'` '.pSQL($order_way);

        if($p !== false && $n !== false)
            $limit = ' LIMIT '.(((int)$p - 1) * (int)$n).','.(int)$n;




        $sql = 'SELECT a.*, '.$title.'
        FROM '._DB_PREFIX_.'pst_{$entity} a'
        . $join
        . $where
        . $order
        . $limit;

        $results = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);
{if $has_image}
        foreach($results as $id => $result){
{foreach $fields as $field}{if $field.type == 'image' || $field.type == 'image' }
            if(file_exists('{$imagePath}/{$field.name}/'.$result['id_{$entity}'] .'.jpg'))
            {
                $results[$id]['{$field.name}'] =  $result['id_{$entity}'] .'.jpg';
                $results[$id]['{$field.name}_path'] =  '{$imageWebPath}/{$field.name}/';
            }
{/if}{/foreach}
        }
{/if}
        return $results;
    }
    /**
     * List of element used for Select|Checkbox
     * @param $id_lang
     * @param bool|false $is_required
     * @return array
     */
    public static function getList($id_lang=null, $is_required=false){
        if(is_null($id_lang))
            $id_lang = Context::getContext()->language->id;
        $output = array();
        if(!$is_required){
            $output[] = array(
                'id'=>'',
                'value'=>'',
                'name'=>'',
{if $option.sortable_nested}
                'level_depth'=>0,
{/if}
            );
        }
        $title = '';
        $is_title_lang = false;
        foreach(array('name','title') as $name)
        {
            if(isset(self::$definition['fields'][$name]))
            {
                if(self::$definition['fields'][$name]['lang'])
                {
                    $key = $name;
                    $title = 'al.`'.$name.'` as ' . $key;
                    $is_title_lang = true;
                }
                else
                {
                    $key = $name;
                    $title = 'al.`'.$name.'` as ' . $key;
                }
            }
        }
        if(empty($title)){
            $title = 'a.`id_{$entity}` as name';
            $key = 'name';
        }
        $join ='';
        if($is_title_lang){
            $join = ' LEFT JOIN '._DB_PREFIX_.'pst_{$entity}_lang al on (a.id_{$entity} = al.id_{$entity} AND al.id_lang = '.(int)$id_lang.')';
        }
{if $option.sortable_nested}
        $title .= ', a.level_depth, a.position';
        $join .= ' ORDER BY a.position';
{/if}
        $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS('
            SELECT a.id_{$entity},'.$title.'
            FROM '._DB_PREFIX_.'pst_{$entity} a'.$join
        );

        foreach($result as $item)
        {
            $current = array(
                'id'=>$item['id_{$entity}'],
                'value'=>$item[$key],
                'name'=>$item[$key],
            );
{if $option.sortable_nested}
            $current['level_depth'] = $item['level_depth'];
{/if}
            $output[] = $current;
        }
        return $output;
    }
{if $has_many}
    public function update($null_values = false){
        $return = parent::update($null_values);
        $this->assignAll();
        return $return;
    }
    public function save($null_values = false, $autodate = true){
        $return = parent::save($null_values,$autodate);
        $this->assignAll();
        return $return;
    }
    /**
     * Assign all many to many
     */
    public function assignAll(){
    {foreach from=$fields item=field name=fieldLoop}{if $field.type == 'many_entity'}
        self::assignMany('{$field.entity}', '{$field.name}', $this->id);
    {/if}{/foreach}
    }
    /**
     * Assign many to many for $name
     * @param $name
     * @param $fieldName
     * @param $id_article
     */
    public static function assignMany($name, $fieldName, $id_{$entity}){
        $name = strtolower($name);
        // @TODO : getValue must be outside class (assign ->categories)
        Db::getInstance()->delete(self::$definition['table'].'_'.$name, 'id_{$entity}='.(int)$id_{$entity});
        foreach(self::getManyIds($name,$id_{$entity}) as $id)
            if(Tools::getValue($fieldName.'_'.$id['id'], false) == 'on')
            {
                Db::getInstance()->insert(self::$definition['table'].'_'.$name, array('id_{$entity}'=>$id_{$entity}, 'id_'.$name=>$id['id']));
            }
    }
    /**
     * Get all id for $name many to many
     * @param $name
     * @param $id_article
     * @return array
     */
    public static function getManyId($name, $id_{$entity}){
        $output = array();
        $results = Db::getInstance()->executeS('SELECT id_'.pSQL(strtolower($name)).' as id from '._DB_PREFIX_.self::$definition['table'].'_'.pSQL(strtolower($name)).' where id_{$entity}='.(int)$id_{$entity});
        foreach($results as $val)
        {
            $output[$val['id']] = true;
        }

        return $output;
    }
    public static function getMany($name, $id_{$entity}){
        return Db::getInstance()->executeS('SELECT * from '._DB_PREFIX_.self::$definition['table'].'_'.pSQL(strtolower($name)).' where id_{$entity}='.(int)$id_{$entity});
    }
    public static function getManyIds($name){
        return Db::getInstance()->executeS('SELECT id_'.pSQL($name).' as id from '._DB_PREFIX_.'pst_'.$name);
    }

{/if}
{if $has_image}
    public static function isLangExist($id, $name, $lang)
    {
        return ($id && file_exists(_PS_IMG_DIR_.'{$entity}/'.$name.'/'.$lang.'/'.(int)$id.'.jpg')) ? (int)$id : false;
    }
    public static function getImageName($id, $name, $lang=null)
    {
        if(!is_null($lang) && self::isLangExist($id, $name, $lang))
        {
            return $name.'/'.$lang.'/'.(int)$id.'.jpg';
        }
        elseif(file_exists(_PS_IMG_DIR_.'{$module_name}/{$entity|strtolower}/'.$name.'/'.(int)$id.'.jpg'))
        {
            return $name.'/'.(int)$id.'.jpg';
        }
        return false;
    }
    public function getImages($lang=null){
        if(!(int)$this->id)
            return  false;

        foreach($this->image_list as $image)
            if(is_null($this->{ldelim}$image{rdelim}))
            {
                $this->{ldelim}$image{rdelim} = self::getImageName($this->id,$image,$lang);
            }
    }
    /**
    * Delete images associated with the object
    *
    * @return bool success
    */
    public function deleteImage($force_delete=false, $name=null, $lang=null)
    {
        if(is_null($name))
        {
            foreach($this->image_list as $image)
            {
                $this->deleteImage($force_delete, $image, $lang);
            }
        }
        if(!is_null($lang))
            $path = $lang . '/'.$name;
        else
            $path = $name;

        if (!$this->id)
            return false;

        if ($force_delete || !$this->hasMultishopEntries())
        {
            /* Deleting object images and thumbnails (cache) */
            if ($this->image_dir)
            {
                if (file_exists($this->image_dir.$path.$this->id.'.'.$this->image_format)
                    && !unlink($this->image_dir.$path.$this->id.'.'.$this->image_format))
                    return false;
            }
            if (file_exists(_PS_TMP_IMG_DIR_.$this->def['table'].'_'.$this->id.'.'.$this->image_format)
                && !unlink(_PS_TMP_IMG_DIR_.$this->def['table'].'_'.$this->id.'.'.$this->image_format))
            return false;

            if (file_exists(_PS_TMP_IMG_DIR_.$this->def['table'].'_mini_'.$this->id.'.'.$this->image_format)
                && !unlink(_PS_TMP_IMG_DIR_.$this->def['table'].'_mini_'.$this->id.'.'.$this->image_format))
                return false;

            PstToolsHelper::clearCachePicture($path, $this->id.'.jpg');
            PstToolsHelper::clearCachePicture($path, $this->id.'.png');
        }
        return true;
    }
{/if}
}