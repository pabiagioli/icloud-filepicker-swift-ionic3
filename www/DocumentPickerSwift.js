var exec = require('cordova/exec');

var PLUGIN_NAME = 'DocumentPickerSwift';

var DocumentPickerSwift = {
    coolMethod : function(arg0, success, error) {
        exec(success, error, PLUGIN_NAME, "coolMethod", [arg0]);
    },
    isAvailable : function(success) {
        exec(success, null, PLUGIN_NAME, "isAvailable", []);
    },
    pickFile : function(success, fail,utis) {
        exec(success, fail, PLUGIN_NAME, "pickFile", [utis]);
    }
};

module.exports = DocumentPickerSwift;