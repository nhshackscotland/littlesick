var getLocation = function (found, notFound) {
  navigator.geolocation.getCurrentPosition(found, notFound, { timeout: 3000 });
};

var foundLocation = function (position) {
  window.location = generateUrl(position);
};

var generateUrl = function (position) {
  var long, lat, url;

  long = position.coords.longitude;
  lat  = position.coords.latitude;

  url  = '/list';
  url += '?ll=' + long + ',' + lat;
  url += '&categories=' + getCategories();

  return url;
};

var noLocation = function () {
  $('.spinner').addClass('hide');
  alert('Could not find location');
};

var getCategories = function () {
  var cats = $('li.selected');
  cats = $.map(cats, function(n,i) { return $(n).data('category'); });
  return cats.join(',');
};

$(function () {
  if ($('.search-button').length) {
    $('.search-button').on('click', function (e) {
      $('.spinner').removeClass('hide');
      getLocation(foundLocation, noLocation);
    });

    $('.filters li').on('click', function (e) {
      if ( $(this).hasClass('selected') ) {
        $(this).addClass('unselected').removeClass('selected');
      } else {
        $(this).removeClass('unselected').addClass('selected');
      }
    });
  }
});
