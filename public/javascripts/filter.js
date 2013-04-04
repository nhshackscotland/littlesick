var getLocation = function (found, notFound) {
  navigator.geolocation.getCurrentPosition(found, notFound);
};

var foundLocation = function (position) {
  window.location = generateUrl(position);
}

var generateUrl = function (position) {
  var lat, long, url;

  lat  = position.coords.latitude;
  long = position.coords.longitude;

  url  = '/results?ll=' + lat + ',' + long;

  return url;
}

var noLocation = function () {
  alert('Could not find location');
}

$(document).ready( function () {
  $('.search-button').on('click', function (e) {
    getLocation(foundLocation, noLocation);
  });
});
