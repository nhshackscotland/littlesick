var loadMap = function () {
  var currentPosition = new google.maps.LatLng(
    $('#map').data('longitude'),
    $('#map').data('latitude')
  );

  var map = new google.maps.Map($("#map")[0], {
    zoom      : 8,
    center    : currentPosition,
    mapTypeId : google.maps.MapTypeId.ROADMAP
  });

  var marker = new google.maps.Marker({
    position : currentPosition,
    map      : map,
    title    : 'Current location'
  });

  var plotService = function (i, service) {
    var name = service.location_name;
    var id   = service._id;
    var lat  = service.latitude;
    var long = service.longitude;

    var infowindow = new google.maps.InfoWindow({
      content: '<div id="content"><a href="#" data-href="/details/' + id + '">' + name + '</a></div>'
    });

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, long),
      map: map,
      title: name
    });

    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
  };

  $.getJSON('/data.json', function(data) { $.each(data, plotService) });
};

$(function() {
  if($('#map').length) { loadMap() }
});

