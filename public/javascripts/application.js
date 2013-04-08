$(function () {
  var linksAreFun = function(e) {
    e.preventDefault();
    window.location = $(this).data('href');
  };

  $(document).on('click', "[data-href]", linksAreFun);
  $(document).on('touchend', "[data-href]", linksAreFun);

  $('#details-back').on('click', function (e) {
    history.go(-1);
  });
});

