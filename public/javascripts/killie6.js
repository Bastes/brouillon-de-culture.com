$(function() {
  $('<div/>')
    .css({
      zIndex: 3000,
      position: 'absolute',
      top: '50%',
      left: '50%',
      width: '1024px',
      height: '768px',
      marginLeft: '-512px',
      marginTop: '-384px',
      border: 'solid 2px red',
      backgroundColor: '#fee',
      overflow: 'auto' })
    .appendTo('body')
    .append($('<div/>').css({ padding: '10px' }).load('/killie6.html'));
});
