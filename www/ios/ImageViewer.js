/**
  Maycur Image Viewer Plugin
  https://github.com/easyfisher/maycur-plugin-image-viewer

  Copyright (c) Easter Dong 2016
*/

var exec = require('cordova/exec');

var ImageViewer = function() {

}

ImageViewer.show = function(urls, index) {
    exec(null,
      null,
      "ImageViewer",
      "show",
      [urls, index]
    );
};

module.exports = ImageViewer;