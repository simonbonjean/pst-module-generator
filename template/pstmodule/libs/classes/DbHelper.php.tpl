<?php
/**
 * User: Simon Bonjean
 * Date: 21/06/13
 * Time: 12:38
 */

class Db{$module_name}HelperCore extends PstDbHelper{

{foreach from=$fixtures key=model item=data}
    public static function import{$model}Fixture(){
        $data = {if $data != ''}{$data}{else}false{/if};
        if($data)
            self::importFixtures('{$model}', $data);
    }
{/foreach}

}