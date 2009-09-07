$(function() {
  $('.index a').live('click', function() {
    myself = $(this);
    var action = false;
    try { action = myself.attr('href').match(/\/(new|edit|remove)\b/)[1]; }
    catch(expt) {}
    if (action) {
      if (action == 'new') {
        $('<div/>').addClass('item').appendTo($('<li/>')).load(myself.attr('href') + ' #view > *', function() {
          $(this)
            .find('input[type=submit]').prev('a').click(function(event) {
              event.preventDefault();
              $(this).closest('.item').slideUp('slow', function() { $(this).closest('li').remove()});
            }).end().end()
            .hide()
            .closest('li').prependTo(myself.parent().children('ul:first'))
            .find('.item:first').slideDown('slow');
        });
      }
      else if (action == 'edit') {
        myself.closest('.item').fadeOut('slow', function() {
          $(this).load(myself.attr('href') + ' #view > *', function() {
            $(this).fadeIn('slow').find('input[type=submit]').prev('a').click(function(event) {
              event.preventDefault();
              var myself = $(this);
              myself.closest('.item').fadeOut('slow', function() {
                $(this).load(myself.attr('href') + ' #view .item:first', function() {
                  $(this).fadeIn('slow');
                });
              });
            });
          });
        });
      }
      else if (action == 'remove') {
        $('<div/>').load(myself.attr('href') + ' #view > *', function() {
          $(this).find('a').click(function(event) {
            event.preventDefault();
            $.modal.close();
          })
          .end()
          .find('form').submit(function(event) {
            event.preventDefault();
            $.post($(this).attr('action'), $(this).serialize(), function(data) {
              myself.closest('li').fadeOut('slow', function() { $(this).remove(); });
              $.modal.close();
            }, 'html');
          })
          .end().modal();
        });
      }
      return false;
    }
    return true;
  });

  $('ul form').live('submit', function() {
    myself = $(this);
    var action = myself.find('input[name=_method]').val();
    if (! action) action = myself.attr('method');
    if (action.match(/put|post|delete/)) {
      if (! action.match(/delete/)) {
        $.post(myself.attr('action'), myself.serialize(), function(data) {
          myself.closest('.item').fadeOut('slow', function() {
            myself.closest('.item').empty()
              .append($('#view .item:first', data).find('.nav').remove().end()) // FIXME : inadequate selector when an error occured
              .fadeIn('slow');
          });
        }, 'html');
      }
      return false;
    }
    return true;
  });

  $.beautyOfCode.init({
    brushes: ['Xml', 'JScript', 'Css', 'Ruby'],
    theme: 'Default'
  });
});
