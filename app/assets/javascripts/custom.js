// Overrides and adds customized javascripts in this file
// Read more on documentation: 
// * English: https://github.com/consul/consul/blob/master/CUSTOMIZE_EN.md#javascript
// * Spanish: https://github.com/consul/consul/blob/master/CUSTOMIZE_ES.md#javascript
//
//

$(document).ready(function() {
  $('.orbit').on('beforeslidechange.zf.orbit', function() {
    $('figure iframe').each(function() {
      $(this)[0].contentWindow.postMessage('{"event":"command","func":"' + 'pauseVideo' + '","args":""}', '*');
    })
  })
})
