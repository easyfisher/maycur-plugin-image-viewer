/**
  Maycur Image Viewer Plugin
  https://github.com/easyfisher/maycur-plugin-image-viewer

  Copyright (c) Easter Dong 2016
*/

var exec = require('cordova/exec');

var ImageViewer = function() {

}

ImageViewer.show = function(options) {

    exec(null,
      null,
      "MCImageViewer",
      "show",
      [options]
    );
};

ImageViewer.alert = function() {  
    alert("I am a js plugin");  
}; 

module.exports = ImageViewer;