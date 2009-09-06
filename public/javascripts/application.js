$(function() {
  $('a').live('click', function() {
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
              $(this).closest('li').remove();
            })
            .end().end()
            .closest('li')
            .prependTo(myself.parent().children('ul:first'));
        });
      }
      else if (action == 'edit') {
        myself.closest('.item').load(myself.attr('href') + ' #view > *', function() {
          $(this).find('input[type=submit]').prev('a').click(function(event) {
            event.preventDefault();
            $(this).closest('.item').load($(this).attr('href') + ' #view .item:first');
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
              myself.closest('li').remove();
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
          $('#view .item:first', data)
            .find('.nav').remove().end()
            .appendTo(myself.closest('.item').empty());
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
