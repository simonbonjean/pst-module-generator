/**
 *
 * @param entityName
 * @returns {boolean}
 */
var isValidEntityName = function(entityName){
    var test = new RegExp(/^[A-Za-z]{3,50}$/);
    return test.test(entityName);
};
/**
 *
 * @param fieldName
 * @returns {boolean}
 */
var isValidFieldName = function(fieldName){
    var test = new RegExp(/^[a-z_]{3,50}$/);
    return test.test(fieldName);
};
/**
 *
 * @param entityName
 * @param fieldName
 * @param fieldType
 * @param fieldDesc
 * @param isRequired
 */
var addField = function(entityName, fieldName,fieldType,fieldDesc,isRequired,entity){
    if(fieldType != 'id_entity' && fieldType != 'many_entity' && fieldType != 'id_entity_full')
        entity = false;


    entityData[entityName]['fields'][fieldName] = {
        name: fieldName,
        type: fieldType,
        desc: fieldDesc,
        required: isRequired,
        entity: entity
    };
    generateHidden();
}
/**
 *
 * @param entityName
 * @param options
 */
var addEntity = function(entityName, entityNameFront, options){
    entityData[entityName] = {options:options, fields:{}, front_name: entityNameFront};
    generateHidden();
};
/**
 *
 * @param entityName
 * @param options
 * @returns {string}
 */
var displayHtmlFieldForm = function(isRequired,fieldType,fieldName,entity){
    var close = '<a class="btn removeField btn-default" href="#">';
    close += '  <i class="icon-remove"></i>';
    close += '</a>';

    if(fieldType == 'id_entity' || fieldType == 'many_entity' || fieldType == 'id_entity_full')
    {
        fieldType = entity;
    }

    var element = '<div class="fieldItem" id="'+fieldName+'">';
    element += '<h3>' + close;
    element += '<input type=checkbox name="required"' + (isRequired?'checked=checked':'') + ' />'
    element += '<span class="type">' + fieldType + '</span>';
    element += '<input type="text" name="fieldNameLive" value="' + fieldName+ '" /></h3>';
    element += '<div class="clear"></div>';
    element += '</div>';
    return element;
}
/**
 *
 * @param entityName
 * @param options
 * @returns {string}
 */
var displayHtmlEntityForm = function(entityName, entityFrontName,options){
    var element = '<div class="entityItem" id="entity_'+entityName+'">';
    var close = '<a class="btn removeEntity btn-default" href="#">';
    close += '  <i class="icon-remove"> '+tradRemove+'</i>';
    close += '</a>';

    if(typeof(entityFrontName) == 'undefined')
        displayEntityFrontName = '';
    else
        displayEntityFrontName  = entityFrontName;

    element += '<h2 style="float: left; margin-right: 15px; margin-top: 0;" id="'+entityName+'">';
    element += '    <input type="text" value="'+entityName+'" name="entityName" /> ';
    element += '    <input type="text" value="'+displayEntityFrontName +'" name="displayEntityFrontName" />';
    element += '</h2>';
    element += close;
    element += '<div style="clear: both"></div>';

    for(id in boolean_options)
    {
        var option = boolean_options[id];
        if(id == 'find_fixtures' && !has_fixtures)
            continue ;
        element += '<div style="float: left; margin-left: 15px;" class="option" rel="'+id+'">'
        element += '<input class="option-check" type="checkbox" id="'+id+'-'+entityName+'" name="'+id+'"';
        if(options[id])
            element += ' checked=checked';

        element += '>';
        element += '<label for="'+id+'-'+entityName+'">';
        element += boolean_options[id].title + '</label></div>';
    }


    element += '<div class="addFieldContainer" style="clear: both; width: 50%; float: left">';

    element += '<input placeholder="'+tradFieldName+'" class="form-placeholder-input" name="fieldName" type="text" />';
    element += '<input placeholder="'+tradFieldDesc+'" class="form-placeholder-input" name="fieldDesc" type="text" />';

    element += '<select class="fieldType" name="fieldType">';
    for(id in entities_type)
    {
        var type = entities_type[id];
        element += '<option value='+id+'>';
        element += id;
        element += '</option>';

    }
    element += '</select>';


    element += '<select style="display:none" class="entity_list" name="entity_list"></select>';

    element += '<div class="form-checkbox-container">';
    element += '<input id="fieldRequired'+entityName+'" name="fieldRequired" type="checkbox" />';
    element += '<label for="fieldRequired'+entityName+'">Required </label>';
    element += '</div>';

    element += '<a class="btn addField btn-default" href="#">';
    element += '  <i class="icon-add"> '+tradAddField+'</i>';
    element += '</a>';
    element += '</div>';
    element += '<div style="margin-top: 22px; float: left; width: 50%;" class="fieldsContainer"></div>';
    element += '<div style="clear: both"></div>';
    element += '</div>';

    return element;
}
/**
 *
 */
var generateHidden = function(){
    $('#entityDataInput').val(JSON.stringify(entityData))
};

/**
 *
 * @returns {string}
 */
String.prototype.ucfirst = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
/**
 *
 * @param e
 */
var fieldsRemove = function(e){
    e.preventDefault();
    var item = $(this);
    var fieldsContainer = item.parents('.fieldItem');
    var fieldName = fieldsContainer.attr('id');
    var entityName = fieldsContainer.parents('.entityItem').find('h2').attr('id');

    fieldsContainer.remove();
    var fields = entityData[entityName].fields;
    delete fields[fieldName];
    generateHidden();
}
/**
 *
 * @param e
 */
var entitiesRemove = function(e){
    e.preventDefault();
    var item = $(this);
    var fieldsContainer = item.parents('.entityItem').find('.fieldsContainer');
    var entityName = fieldsContainer.parent().find('h2').attr('id');
    item.parent().remove();
    delete entityData[entityName];
    generateHidden();
}

var modifyOption = function(e){
    var item = $(this);
    var entityContainer = item.parents('.entityItem');
    var fieldsContainer = entityContainer.find('.fieldsContainer');
    var entityName = fieldsContainer.parent().find('h2').attr('id');


    if(item.attr('name') == 'sortable_flat')
    {
        entityContainer.find('input[name=sortable_nested]').attr('checked', false);
        entityData[entityName]['options']['sortable_nested'] = false;
    }
    else if(item.attr('name') == 'sortable_nested')
    {
        entityContainer.find('input[name=sortable_flat]').attr('checked', false);
        entityData[entityName]['options']['sortable_flat'] = false;
    }


    entityData[entityName]['options'][item.attr('name')] = item.attr('checked') == 'checked';
    generateHidden();
}
/**
 *
 * @param e
 */
var fieldAdd =function(e){
    e.preventDefault();
    var item = $(this);
    var container = item.parent();
    var inputName = container.find('input[name=fieldName]');
    var inputDesc = container.find('input[name=fieldDesc]');
    var inputRequired = container.find('input[name=fieldRequired]');
    var isRequired = inputRequired.attr('checked') == 'checked';
    var fieldName = inputName.val().toLowerCase();
    var fieldType = container.find('select[name=fieldType]').val();
    var fieldsContainer = item.parents('.entityItem').find('.fieldsContainer');
    var entityName = fieldsContainer.parent().find('h2').attr('id');
    var entity_list = container.find('.entity_list')
    var entity = entity_list.val();

    if(!isValidFieldName(fieldName))
    {
        alert('entity name is not valide');
        return ;
    }
    if(typeof(entityData[entityName]['fields'][fieldName])!='undefined')
    {
        alert('field name already set');
        return ;
    }

    inputName.val('');
    var fieldDesc = inputDesc.val();
    inputDesc.val('');

    var htmlElement = displayHtmlFieldForm(isRequired, fieldType,fieldName,entity);
    addField(entityName, fieldName, fieldType, fieldDesc, isRequired, entity);
    fieldsContainer.append(htmlElement);
    generateHidden();
};

var entitiesAdd = function(e){
    e.preventDefault();
    var item = $(this);
    var input = item.next();
    var inputFrontName = input.next();

    var entityName = input.val();
    var entityFrontName = inputFrontName.val();
    var options = {};

    input.val('');
    inputFrontName.val('');
    entityName = entityName.ucfirst();
    entityFrontName = entityFrontName.ucfirst();

    if(!isValidEntityName(entityName))
    {
        alert('entity name is not valide');
        return ;
    }
    if(typeof(entityData[entityName])!='undefined')
    {
        alert('entity name already set');
        return ;
    }



    var htmlElement = displayHtmlEntityForm(entityName, entityFrontName,options);
    addEntity(entityName, entityFrontName, options);
    $('#entitiesContainer').append(htmlElement);
};
/**
 *
 */
var entitiesLoader = function(){

    if(initial_entities != '')
        entityData = initial_entities;


    for(entity in entityData)
    {
        var dataEntity = entityData[entity];
        var fields = dataEntity.fields;
        var entityFrontName = dataEntity.front_name;

        var htmlElement = displayHtmlEntityForm(entity, entityFrontName, dataEntity.options);
        $('#entitiesContainer').append(htmlElement);
        for(field in fields)
        {
            var dataField = fields[field];
            var htmlElement = displayHtmlFieldForm(dataField.required, dataField.type, field, dataField.entity);
            fieldsContainer = $('#entity_'+entity + ' .fieldsContainer');
            fieldsContainer.append(htmlElement);
        }
    }
    generateHidden();
};

var showEntities = function(){
    var item = $(this);
    var entity_list = item.parent().find('.entity_list');
    if(item.val() == 'id_entity' || item.val() == 'many_entity' || item.val() == 'id_entity_full')
    {
        entity_list.show();
        var current_entity = item.parent().parent().find('h2').attr('id').toLowerCase();
        var option = '';
        for(entity in entityData)
        {
            var dataEntity = entityData[entity];
            if(current_entity != entity)
            {
                option += '<option value="'+entity+'">' + entity + '</option>';
            }
        }

        entity_list.html(option);
    }
    else{
        entity_list.hide();
    }
};
var modifyEntityFrontName = function(){
    var item = $(this);
    var entityName = item.parent().attr('id');
    var entityFrontName = item.val();
    if(entityFrontName != '')
    {
        entityData[entityName]['front_name'] = entityFrontName;
        generateHidden();
    }
};
var modifyEntityName = function(){
    var item = $(this);
    var entityName = item.parent().attr('id');
    var newEntityName = item.val();
    item.parent().attr('id', newEntityName);
    var clone = entityData[entityName];
    if(entityName != '')
    {
        delete entityData[entityName];
        entityData[newEntityName] = clone;
        generateHidden();
    }
};
var modifyRequired = function(){
    var item = $(this);
    var entityContainer = item.parents('.entityItem');
    var container = item.parents('.fieldItem');
    var entityName = entityContainer.find('h2').attr('id');
    var fieldName = container.attr('id');
    var checked = item.attr('checked') == 'checked';
    entityData[entityName]['fields'][fieldName]['required'] = checked;
    generateHidden();

};
var modifyFieldName = function(){
    var item = $(this);
    var entityContainer = item.parents('.entityItem');
    var container = item.parents('.fieldItem');
    var entityName = entityContainer.find('h2').attr('id');
    var fieldName = container.attr('id');
    var clone = entityData[entityName]['fields'][fieldName];
    delete entityData[entityName]['fields'][fieldName];
    entityData[entityName]['fields'][item.val()] = clone;
    generateHidden();

};

$(function(){
    entitiesLoader();
    $('.removeEntity').live('click', entitiesRemove);
    $('.removeField').live('click', fieldsRemove);
    $('.addField').live('click', fieldAdd);
    $('.fieldType').live('change', showEntities);
    $('.option-check').live('change', modifyOption);
    $('input[name=entityName]').live('change', modifyEntityName);
    $('input[name=displayEntityFrontName]').live('change', modifyEntityFrontName);
    $('input[name=required]').live('change', modifyRequired);
    $('input[name=fieldNameLive]').live('change', modifyFieldName);
    $('#addEntities').click(entitiesAdd);
});