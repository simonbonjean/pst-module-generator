        /*
         *  SQL installation for {$entity_model} Model
         */
        $query = '
            CREATE TABLE IF NOT EXISTS '._DB_PREFIX_.'pst_{$entity} (
            `id_{$entity}` int(10) NOT NULL AUTO_INCREMENT,
{foreach from=$fields item=field name=fieldLoop}{if !$field.is_multi_lang && $field.form_type != file && $field.type != 'many_entity'}
            `{$field.name}` {$field.dbDesc},
{/if}{/foreach}
{if $option.linkable}
            `type` VARCHAR(255) NOT NULL,
            `css` VARCHAR(255) NOT NULL,
            `display_prod_cat_childs` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `display_cms_cat_childs` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `new_window` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `member_only` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `guest_only` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `has_anchor` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `no_follow` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `lightbox` tinyint(1) unsigned NOT NULL DEFAULT 0,
            `lightbox_height` int(11) unsigned NOT NULL DEFAULT 0,
            `lightbox_width` int(11) unsigned NOT NULL DEFAULT 0,
            `id_cms` int(11) NOT NULL,
            `id_category` int(11) NOT NULL,
            `id_meta` int(11) NOT NULL,
            `id_cms_category` int(11) NOT NULL,
            `id_manufacturer` int(11) NOT NULL,
            `id_supplier` int(11) NOT NULL,
            `id_product` int(11) NOT NULL,
            `id_attachment` int(11) NOT NULL,
{/if}
{if $option.active}
            `active` tinyint(1) unsigned NOT NULL DEFAULT 0,
{/if}
{if $option.date_add}
            `date_add` DATETIME NOT NULL,
{/if}
{if $option.date_upd}
            `date_upd` DATETIME NOT NULL,
{/if}
{if $option.sortable_flat}
            `position` int(10) unsigned NOT NULL DEFAULT 0,
{/if}
{if $option.sortable_nested}
            `position` int(10) unsigned NOT NULL DEFAULT 0,
            `id_parent` int(11) NOT NULL,
            `level_depth` tinyint(3) unsigned NOT NULL DEFAULT 0,
            `nleft` int(10) unsigned NOT NULL DEFAULT 0,
            `nright` int(10) unsigned NOT NULL DEFAULT 0,
{/if}
            PRIMARY KEY(`id_{$entity}`)
            ) ENGINE=MyISAM default CHARSET=utf8';

        if (!Db::getInstance()->Execute($query))
        return $this->_abortInstall('Unable to create table '._DB_PREFIX_.'pst_{$entity}');

{foreach from=$fields item=field name=fieldLoop}{if $field.type == 'many_entity'}
        $query = '
            CREATE TABLE IF NOT EXISTS '._DB_PREFIX_.'pst_{$entity|lower}_{$field.entity|lower} (
                `id_{$entity|lower}` int(11) unsigned NOT NULL,
                `id_{$field.entity|lower}` int(11) unsigned NOT NULL
            ) ENGINE=MyISAM default CHARSET=utf8';
        if (!Db::getInstance()->Execute($query))
            return $this->_abortInstall('Unable to create table '._DB_PREFIX_.'pst_{$entity|lower}_{$field.entity|lower}');
{/if}{/foreach}

{if $is_multi_lang}
        $query = '
            CREATE TABLE IF NOT EXISTS '._DB_PREFIX_.'pst_{$entity}_lang (
            `id_{$entity}` int(10) NOT NULL AUTO_INCREMENT,
            `id_lang` int(10) NOT NULL,
{if $option.link_rewrite}
            `link_rewrite` varchar(128) NOT NULL,
{/if}
{foreach from=$fields item=field name=fieldLoop}{if $field.is_multi_lang}
            `{$field.name}` {$field.dbDesc},
{/if}{/foreach}
            PRIMARY KEY(`id_{$entity}`,`id_lang`)
            ) ENGINE=MyISAM default CHARSET=utf8';

        if (!Db::getInstance()->Execute($query))
            return $this->_abortInstall('Unable to create table '._DB_PREFIX_.'pst_{$entity}_lang');
{/if}
