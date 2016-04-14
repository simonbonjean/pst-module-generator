{if $show_toolbar && !$isPresta16}
{include file="toolbar.tpl" toolbar_btn=$toolbar_btn toolbar_scroll=$toolbar_scroll title=$title}
<div class="leadin">{block name="leadin"}{/block}</div>
{/if}

{include file="helpers/javascript.tpl"}
{$content}