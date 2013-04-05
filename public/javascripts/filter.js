var getLocation = function (found, notFound) {
  navigator.geolocation.getCurrentPosition(found, notFound);
};

var foundLocation = function (position) {
  window.location = generateUrl(position);
};

var generateUrl = function (position) {
  var lat, long, url;

  lat  = position.coords.latitude;
  long = position.coords.longitude;

  url  = '/list'
  url += '?ll=' + lat + ',' + long;
  url += '&categories=' + getCategories();

  return url;
};

var noLocation = function () {
  alert('Could not find location');
};

var getCategories = function () {
  var cats = $('.toggle.active').closest('li');
  cats = $.map(cats, function(n,i) { return $(n).data('category'); });
  return cats.join(',');
};

$(function () {
  if ($('.search-button').length) {
    $('.search-button').on('click', function (e) {
      getLocation(foundLocation, noLocation);
    });
  }
});

