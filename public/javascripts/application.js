$(function() {
  var fadeNotices = function() {
    $('#notices div').animate({ opacity: 1 }, { duration: 3000, complete: function() {
      $(this).fadeOut('slow');
    } });
  };

  var formAction = function(form) {
    var action = form.find('input[name=_method]').val();
    if (! action) action = form.attr('method');
    return action;
  };

  $('.index a').live('click', function() {
    myself = $(this);
    var action = false;
    try { action = myself.attr('href').match(/\/(new|edit|remove)\b/i)[1]; }
    catch(expt) {}
    if (action) {
      if (action == 'new') {
        $('<div/>').addClass('item').appendTo($('<li/>')).load(myself.attr('href') + ' #view > *', function() {
          $(this).hide()
            .closest('li').prependTo(myself.parent().children('ul:first'))
            .find('.item:first').slideDown('slow');
        });
      }
      else if (action == 'edit') {
        myself.closest('.item').fadeOut('slow', function() {
          $(this).load(myself.attr('href') + ' #view > *', function() {
            $(this).fadeIn('slow');
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
    var myform = myself.closest('form');
    if (myform.length > 0) {
      var action = formAction(myform);
      if (action.match(/post|put/i)) {
        if (action.match(/post/i))
          myself.closest('.item').slideUp('slow', function() { $(this).closest('li').remove()});
        else {
          myself.closest('.item').fadeOut('slow', function() {
            $(this).load(myself.attr('href') + ' #view .item:first', function() {
              $(this).fadeIn('slow');
            });
          });
        }
        return false;
      }
    }
    return true;
  });

  $('ul form').live('submit', function() {
    myself = $(this);
    var action = formAction(myself);
    if (action.match(/put|post|delete/i)) {
      if (! action.match(/delete/i)) {
        $.ajax({
          type: "POST",
          url: myself.attr('action'),
          data: myself.serialize(),
          dataType: 'html',
          success: function(data) {
            $('#notices').append($('#notices > *', data));
            fadeNotices();
            myself.closest('.item').fadeOut('slow', function() {
              var new_content = $('#view .item:first', data).find('.nav').remove().end();
              if (action.match(/put/)) $('.' + $(this).attr('class').match(/\b\w+_\d+\b/)[0]).html(new_content);
              else $(this).html(new_content);
              $(this).fadeIn('slow');
            });
          },
          error: function(XMLHttpRequest, textStatus, errorThrown) {
            myself.closest('.item').html($('#view > *', XMLHttpRequest.responseText));
          }
        });
      }
      return false;
    }
    return true;
  });
 
  fadeNotices();

  $.beautyOfCode.init({
    brushes: ['Xml', 'JScript', 'Css', 'Ruby'],
    theme: 'Default'
  });
});
