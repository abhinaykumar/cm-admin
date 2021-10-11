var currentRequest = null
$(document).ready(function(e) {
  if ($('.index-page__table-container').length > 0) {
    return currentRequest = $.ajax(window.location.href, {
      type: 'GET',
      data: {
        tableColumn: getTableColumns(),
      },
      beforeSend: function() {
        if (currentRequest !== null) {
          currentRequest.abort();
        }
      },
      success: function(data) {
        $('.index-page__table-container').html(data);
        initalizeSortable();
      },
      error: function(jqxhr, textStatus, errorThrown) {
        console.log(errorThrown, textStatus);
      }
    });
  }
});

window.getTableColumns = function() {
  var tableColumn;
  var pathname = window.location.pathname.split('cm_admin/').slice(-1)[0]
  var entity = pathname.split('/').filter(x => x != '')
  var pageType = entity.length  == 1 ? 'index' : 'show'

  var storageName = entity[0] + '_' + pageType
  if (window.localStorage.getItem(storageName) != null) {
    tableColumn = window.localStorage.getItem(storageName)
  } else {
    url = '/cm_admin/hashed_columns.json?pathname=' + pathname
    fetch(url).then(function(res){
      return res.json()
    }).then(function(myJson) {
      tableColumn = JSON.stringify(myJson)
      window.localStorage.setItem(storageName, tableColumn)
    });
  }
  return tableColumn
}

window.initalizeSortable = function() {
  if ($('.columns-list').length > 0) {
    Sortable.create($('.columns-list')[0],{
      handle: '.dragger',
      animation: 150
    });
  }
}
