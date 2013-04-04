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
});
