
module.declare(['spinning', 'jquery'], function(require) {

  var $ = require('jquery');

  $(document).ready(function() {
    require('spinning').spinning($('#followIcons a'));
    $('#followIcons').show();
  })

});
