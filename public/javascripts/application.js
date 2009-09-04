$(function() {
  $('a').live('click', function() {
    myself = $(this);
    var action = false;
    try { action = myself.attr('href').match(/\/(new|edit|remove)\b/)[1]; }
    catch(expt) {}
    if (action) {
      if (action == 'new') {
        $('<li/>').load(myself.attr('href') + ' #view', function() {
          $(this).appendTo(myself.prev('ul'));
        });
      }
      else if (action == 'edit') {
        myself.closest('li').load(myself.attr('href') + ' #view');
      }
      else if (action == 'remove');
      return false;
    }
    return true;
  });

  $('form').live('submit', function() {
    myself = $(this);
    console.log($(this));
    var action = myself.find('input[name=_method]').val();
    if (! action) action = myself.attr('method');
    if (action.match(/put|post|delete/)) {
      if (action.match(/delete/));
      else {
        $.post(myself.attr('action'), myself.serialize(), function(data) {
          $('#view', data)
            .find('.nav').remove().end()
            .appendTo(myself.closest('li').empty());
        }, 'html');
      }
      return false;
    }
    return true;
  });
});
