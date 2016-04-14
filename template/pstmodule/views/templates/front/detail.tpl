{ldelim}capture name=path{rdelim}{ldelim}l s='{$entity}'{rdelim}{ldelim}/capture{rdelim}

<div class="element">
    {foreach $data.fields as $field}
        <div class="{$field.type}-{$field.name}">
            {if $field.type == 'text' || $field.type == 'text_lang' }

                <h1>{ldelim}$element->{$field.name}{rdelim}</h1>

            {elseif $field.type == 'image' || $field.type == 'image_ml' }

                {ldelim}if isset($element->{$field.name}) && isset($element->{$field.name}_path){rdelim}
                <img class="img-responsive" src="{ldelim}imageResize name=$element->{$field.name} path=$element->{$field.name}_path width=500 height=500{rdelim}" />
                {ldelim}/if{rdelim}
            {elseif $field.type == 'textarea_ml' || $field.type == 'textarea_lang'  || $field.type == 'textarea_rte_lang'  || $field.type == 'textarea_rte'}
                <div class="rte">{ldelim}$element->{$field.name}{rdelim}</div>
            {elseif $field.type == 'datetime'  || $field.type == 'date'}
                <div class="date">
                    {ldelim}$element->{$field.name}|date_format{rdelim}
                </div>
            {elseif $field.type == 'many_entity'  || $field.type == 'id_entity'}

            {else}

                {ldelim}$element->{$field.name}{rdelim}
            {/if}

        </div>
    {/foreach}
</div>