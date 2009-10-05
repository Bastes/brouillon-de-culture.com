(function($) { $(function() {
  if (navigator.appName.match(/Microsoft Internet Explorer/i))
    throw('Quel dommage, avec un vrai navigateur il y aurait une jolie petite animation à afficher. Malheureusement vous avez Internet Explorer, et je n\'ai pas vraiment envie de passer des heures à essayer de trouver un moyen de contourner le mauvais support des css, du javascript et de la transparence png, sans lesquels la jole animation n\'est plus jolie ni animée. Donc tant pis pour vous, à moins que vous essayez de passer à un vrai navigateur, comme Firefox : http://www.mozilla-europe.org/fr/firefox/. Bonne journée.');

  var image = new Image();
  image.src = '/images/anims/fluo-sprite.png';
  var width = 119;
  var height = 21;
  var frames = 10;

  var fluo_sprite = function() {
    var target = $('#view a, #sideways a').random();
    var offset = target.offset();
    var actual_frames = 10;
    var fraction = (target.width() + 20) / width;
    if (fraction < 1) actual_frames = Math.ceil(frames * fraction);
    $('<div />')
      .css({
        position: 'absolute',
        top: (offset.top - (height - target.height()) / 2) + 'px',
        left: (offset.left - 10) + 'px',
        width: width + 'px',
        height: height + 'px',
        background: 'transparent url(' + image.src + ') 0 0 no-repeat',
        zIndex: 100
      })
      .click(function() { $(this).remove(); target.click(); })
      .appendTo('body')
      .sprite(actual_frames, { complete: function() {
        $(this).animate({ opacity: 1 }, { duration: 60000, complete: function() {
          $(this).remove(); fluo_sprite(); } } ) } });
  };
  $('body').animate({ opacity: 1 }, { duration: 1000, complete: function() { fluo_sprite(); } });
}); })(jQuery);
