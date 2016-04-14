<?php
/**
 * User: Simon Bonjean
 * Date: 21/06/13
 * Time: 12:38
 */

class {$module_name}LinkCore extends Link{
{foreach from=$entities key=entity item=data}{if $data.options.front_controller_detail && $data.options.link_rewrite}
    /**
	 * Create a link to a {$entity}
	 *
	 * @param mixed ${$entity|lower} {$entity} object (can be an ID {$entity|lower}, but deprecated)
	 * @param string $alias
	 * @param int $id_lang
	 * @return string
	 */
	public function get{$entity}Link(${$entity|lower},  $alias = null, $ssl = null, $id_lang = null, $id_shop = null, $relative_protocol = false)
	{
        $rule = 'module-{$module_name|lower}-{$entity|lower}detail';
		if (!$id_lang)
			$id_lang = Context::getContext()->language->id;

        $url = $this->getBaseLink($id_shop, $ssl, $relative_protocol).$this->getLangLink($id_lang, null, $id_shop);
        
        $dispatcher = Dispatcher::getInstance();
        if (!is_object(${$entity|lower}))
        {
            if ($alias !== null)
                return $url.$dispatcher->createUrl($rule, $id_lang, array('id' => (int)${$entity|lower}, 'link_rewrite' => (string)$alias), $this->allow, '', $id_shop);

            ${$entity|lower} = new {$entity}(${$entity|lower}, $id_lang);
        }
        
        // Set available keywords
        $params = array();
        $params['id'] = ${$entity|lower}->id;
        $params['link_rewrite'] = (!$alias) ? (is_array(${$entity|lower}->link_rewrite) ? ${$entity|lower}->link_rewrite[(int)$id_lang] : ${$entity|lower}->link_rewrite) : $alias;

{if $data.options.meta}
        $params['meta_keywords'] = '';
        if (isset(${$entity|lower}->meta_keywords) && !empty(${$entity|lower}->meta_keywords))
            $params['meta_keywords'] = is_array(${$entity|lower}->meta_keywords) ?  Tools::str2url(${$entity|lower}->meta_keywords[(int)$id_lang]) :  Tools::str2url(${$entity|lower}->meta_keywords);
        
        $params['meta_title'] = '';
        if (isset(${$entity|lower}->meta_title) && !empty(${$entity|lower}->meta_title))
            $params['meta_title'] = is_array(${$entity|lower}->meta_title) ? Tools::str2url(${$entity|lower}->meta_title[(int)$id_lang]) : Tools::str2url(${$entity|lower}->meta_title);
{/if}

        return $url.$dispatcher->createUrl($rule, $id_lang, $params, $this->allow, '', $id_shop);
    }
{/if}{/foreach}
}