/**
 *
 * @param fieldsetName
 * @returns {boolean}
 */
var isValidFieldsetName = function(fieldsetName){
    var test = new RegExp(/^[A-Za-z]{3,50}$/);
    return test.test(fieldsetName);
};
/**
 *
 * @param configFieldName
 * @returns {boolean}
 */
var isValidFieldName = function(configFieldName){
    var test = new RegExp(/^[a-z_]{3,50}$/);
    return test.test(configFieldName);
};
/**
 *
 * @param fieldsetName
 * @param configFieldName
 * @param configFieldType
 * @param configFieldDesc
 * @param isRequired
 */
var addConfigField = function(configFieldsetName, configFieldName,configFieldType,configFieldDesc,isRequired,fieldset){

    fieldsetData[configFieldsetName]['configFields'][configFieldName] = {
        name: configFieldName,
        type: configFieldType,
        desc: configFieldDesc,
        required: isRequired,
        fieldset: fieldset
    };
    generateConfigurationHidden();
}
/**
 *
 * @param fieldsetName
 */
var addFieldset = function(fieldsetName){
    fieldsetData[fieldsetName] = {configFields:{}, front_name: fieldsetName};
    generateConfigurationHidden();
};
/**
 *
 * @param fieldsetName
 * @returns {string}
 */
var displayHtmlConfigFieldForm = function(isRequired,configFieldType,configFieldName,fieldset){
    var close = '<a class="btn removeConfigField btn-default" href="#">';
    close += '  <i class="icon-remove"></i>';
    close += '</a>';

    var element = '<div class="configFieldItem" id="'+configFieldName+'">';
    element += '<h3>' + close;
    element += '<input type=checkbox name="configRequired"' + (isRequired?'checked=checked':'') + ' />'
    element += '<span class="type">' + configFieldType + '</span>';
    element += '<input type="text" name="fieldConfigNameLive" value="' + configFieldName+ '" />';
    element += '<div class="clear"></div>';
    element += '</h3></div>';
    return element;
}
/**
 *
 * @param fieldsetName
 * @returns {string}
 */
var displayHtmlConfigFieldsetForm = function(fieldsetName){
    var element = '<div class="fieldsetItem" id="fieldset_'+fieldsetName+'">';
    var close = '<a class="btn removeFieldset btn-default" href="#">';
    close += '  <i class="icon-remove"> '+tradRemove+'</i>';
    close += '</a>';

    var displayFieldsetFrontName = fieldsetName;

    element += '<h2 style="float: left; margin-right: 15px; margin-top: 0;" id="'+fieldsetName+'">';
    element += '    <input type="text" value="'+fieldsetName+'" name="fieldsetName" /> ';
    element += '</h2>';
    element += close;
    element += "<br />";




    element += '<div class="addFieldConfigContainer" style="clear: both; width: 50%; float: left">';


    element += '<input placeholder="'+tradFieldName+'" class="form-placeholder-input" name="configFieldName" type="text" />';
    element += '<input placeholder="'+tradFieldDesc+'" class="form-placeholder-input" name="configFieldDesc" type="text" />';

    element += '<select class="configFieldType" name="configFieldType">';
    for(id in fieldset_type)
    {
        var type = fieldset_type[id];
        element += '<option value='+id+'>';
        element += id;
        element += '</option>';

    }
    element += '</select>';

    element += '<div class="form-checkbox-container">';
    element += '<input id="configFieldRequired" name="configFieldRequired" type="checkbox" />';
    element += '<label for="configFieldRequired">Required </label>';
    element += '</div>';


    element += '<a class="btn addConfigField btn-default" href="#">';
    element += '  <i class="icon-add"> '+tradAddField+'</i>';
    element += '</a>';

    element += '</div>';

    element += '<div style="margin-top: 22px; float: left; width: 50%;" class="configFieldsContainer"></div>';
    element += '<div style="clear: both"></div>';
    element += '</div>';

    return element;
}
/**
 *ª
 */
var generateConfigurationHidden = function(){
    $('#configurationDataInput').val(JSON.stringify(fieldsetData))
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
var configFieldsRemove = function(e){
    e.preventDefault();
    var item = $(this);
    var configFieldsContainer = item.parents('.configFieldItem');
    var configFieldName = configFieldsContainer.attr('id');
    var fieldsetName = configFieldsContainer.parents('.fieldsetItem').find('h2').attr('id');

    configFieldsContainer.remove();
    var configFields = fieldsetData[fieldsetName].configFields;
    delete configFields[configFieldName];
    generateConfigurationHidden();
}
/**
 *
 * @param e
 */
var configurationRemove = function(e){
    e.preventDefault();
    var item = $(this);
    var configFieldsContainer = item.parents('.fieldsetItem').find('.configFieldsContainer');
    var fieldsetName = configFieldsContainer.parent().find('h2').attr('id');
    item.parent().remove();
    delete fieldsetData[fieldsetName];
    console.info(fieldsetData);
    generateConfigurationHidden();
}
/**
 *
 * @param e
 */
var configFieldAdd =function(e){
    e.preventDefault();
    var item = $(this);
    var container = item.parent();
    var inputName = container.find('input[name=configFieldName]');
    var inputDesc = container.find('input[name=configFieldDesc]');
    var inputRequired = container.find('input[name=configFieldRequired]');
    var isRequired = inputRequired.attr('checked') == 'checked';
    var configFieldName = inputName.val().toLowerCase();
    var configFieldType = container.find('select[name=configFieldType]').val();
    var configFieldsContainer = item.parents('.fieldsetItem').find('.configFieldsContainer');
    var fieldsetName = configFieldsContainer.parent().find('h2').attr('id');
    var fieldset_list = container.find('.fieldset_list')
    var fieldset = fieldset_list.val();

    if(!isValidFieldName(configFieldName))
    {
        alert('fieldset name is not valide');
        return ;
    }
    if(typeof(fieldsetData[fieldsetName]['configFields'][configFieldName])!='undefined')
    {
        alert('config Field name already set');
        return ;
    }

    inputName.val('');
    var configFieldDesc = inputDesc.val();
    inputDesc.val('');

    var htmlElement = displayHtmlConfigFieldForm(isRequired, configFieldType,configFieldName,fieldset);
    addConfigField(fieldsetName, configFieldName, configFieldType, configFieldDesc, isRequired, fieldset);
    configFieldsContainer.append(htmlElement);
};

var configurationAdd = function(e){
    e.preventDefault();
    var item = $(this);
    var input = item.next();

    var name = input.val();


    input.val('');

    if(!isValidFieldsetName(name))
    {
        alert('fieldset name is not valide');
        return ;
    }
    if(typeof(fieldsetData[name])!='undefined')
    {
        alert('fieldset name already set');
        return ;
    }

    var htmlElement = displayHtmlConfigFieldsetForm(name);
    addFieldset(name);
    $('#fieldsetContainer').append(htmlElement);
};
/**
 *
 */
var configurationLoader = function(){

    if(initial_configuration != '')
        fieldsetData = initial_configuration;
    else
        fieldsetData = {};

    for(fieldset in fieldsetData)
    {
        var dataFieldset = fieldsetData[fieldset];
        var configFields = dataFieldset.configFields;
        var htmlElement = displayHtmlConfigFieldsetForm(fieldset);
        $('#fieldsetContainer').append(htmlElement);
        for(configField in configFields)
        {
            var dataField = configFields[configField];
            var htmlElement = displayHtmlConfigFieldForm(dataField.required, dataField.type, configField, dataField.fieldset);
            configFieldsContainer = $('#fieldset_'+fieldset + ' .configFieldsContainer');
            configFieldsContainer.append(htmlElement);
        }
    }
    generateConfigurationHidden();
};
var modifyFieldConfigName = function(){
    var item = $(this);
    var entityContainer = item.parents('.fieldsetItem');
    var container = item.parents('.configFieldItem');
    var fieldsetName = entityContainer.find('h2').attr('id');
    var fieldName = container.attr('id');
    var clone = fieldsetData[fieldsetName]['configFields'][fieldName];
    delete fieldsetData[fieldsetName]['configFields'][fieldName];
    fieldsetData[fieldsetName]['configFields'][item.val()] = clone;
    generateConfigurationHidden();

};

var modifyConfigRequired = function(){
    var item = $(this);
    var entityContainer = item.parents('.fieldsetItem');
    var container = item.parents('.configFieldItem');
    var fieldsetName = entityContainer.find('h2').attr('id');
    var fieldName = container.attr('id');
    var checked = item.attr('checked') == 'checked';
    fieldsetData[fieldsetName]['configFields'][fieldName]['required'] = checked;
    generateConfigurationHidden();

};
var modifyFieldsetName = function(){
    var item = $(this);
    var fieldsetName = item.parent().attr('id');
    var newFieldsetName = item.val();
    item.parent().attr('id', newFieldsetName);
    var clone = fieldsetData[fieldsetName];
    if(fieldsetName != '')
    {
        delete fieldsetData[fieldsetName];
        fieldsetData[newFieldsetName] = clone;
        generateHidden();
    }
};


$(function(){
    configurationLoader();
    $('.removeFieldset').live('click', configurationRemove);
    $('.removeConfigField').live('click', configFieldsRemove);
    $('.addConfigField').live('click', configFieldAdd);
    $('#addConfigFielset').click(configurationAdd);
    $('input[name=fieldConfigNameLive]').live('change', modifyFieldConfigName);
    $('input[name=configRequired]').live('change', modifyConfigRequired);
    $('input[name=fieldsetName]').live('change', modifyFieldsetName);
});