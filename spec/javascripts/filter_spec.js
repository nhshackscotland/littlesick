describe("Filter", function () {
  describe("getLocation", function() {
    it("gets the current location", function() {
      spyOn(navigator.geolocation, 'getCurrentPosition');

      found = function() { };
      notFound = function() { };
      getLocation(found, notFound);
      expect(navigator.geolocation.getCurrentPosition).toHaveBeenCalledWith(found, notFound);
    });
  });

  describe("generateUrl", function() {
    it("provides the current lat and long coordinates", function () {
      result = generateUrl({coords: { latitude: 1, longitude: 2 } });
      expect(result).toContain('ll=1,2');
    });
  });

  describe("noLocation", function() {
    it("Alerts the user that no location was found", function () {
      spyOn(window, 'alert');
      noLocation();
      expect(alert).toHaveBeenCalledWith('Could not find location');
    });
  });

  describe("getCategories", function() {
    it("returns the active categories", function () {
      var filterHtml = ''
      filterHtml += '<li data-category="A"><div class="toggle active"></div></li>';
      filterHtml += '<li data-category="B"><div class="toggle"></div></li>';
      filterHtml += '<li data-category="C"><div class="toggle active"></div></li>';

      $('body').append(filterHtml);

      result = getCategories();
      expect(result).toEqual("A,C");

      $('body li[data-category]').remove();
    });
  });
});
