(function($) { $(function() {
  var image = new Image();
  image.src = '/images/anims/fluo-sprite.png';
  var width = 119;
  var height = 21;
  var frames = 10;

  var fluo_sprite = function() {
    var target = $('#view a, #sideways a').random();
    var offset = target.offset();
    $('<div />')
      .css({
        position: 'absolute',
        top: (offset.top + 2) + 'px',
        left: (offset.left - 10) + 'px',
        width: width + 'px',
        height: height + 'px',
        background: 'url(' + image.src + ') 0 0 no-repeat',
        zIndex: 100
      })
      .appendTo('body')
      .sprite(10, { complete: function() {
        $(this).animate({ opacity: 1 }, { duration: 10000, complete: function() {
          $(this).remove(); fluo_sprite(); } } ) } });
  };
  fluo_sprite();
}); })(jQuery);
