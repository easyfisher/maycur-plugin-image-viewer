/**
  Maycur Image Viewer Plugin
  https://github.com/easyfisher/maycur-plugin-image-viewer

  Copyright (c) Easter Dong 2016
*/

var exec = require('cordova/exec');

function ImageViewer() {
    this._callback;
}

ImageViewer.prototype.show = function(options) {

    exec(null,
      null,
      "MCImageViewer",
      "show",
      [options]
    );
};

var imageViewer = new ImageViewer();
module.exports = imageViewer;

// Make plugin work under window.plugins
if (!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.imageViewer) {
    window.plugins.imageViewer = imageViewer;
}
