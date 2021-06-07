$(document).on('click', '.row-action-tool', function(e) {
    alert("clicked");
    e.stopPropagation();
    if ($('.table-export-popup').hasClass('hidden')) {
      return $('.table-export-popup').removeClass('hidden');
    } else {
      return $('.table-export-popup').addClass('hidden');
    }
  });
