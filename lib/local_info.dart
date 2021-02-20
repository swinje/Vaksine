import 'location.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalInfo {
  Future<Location> getGPSLocation() async {
    Location l;
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permantly denied.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always)
        return Future.error('Location permissions are denied ($permission).');
    }

    if (serviceEnabled) {
      try {
        Position _gpsPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        //if (_gpsPosition.latitude > 50) // Otherwise debug and stuck in Cali
        String knr = await searchMunicipalityGeo(
            _gpsPosition.latitude, _gpsPosition.longitude);

        l = Location(
            id: "local",
            name: "Din posisjon",
            knummer: knr,
            lat: _gpsPosition.latitude,
            lon: _gpsPosition.longitude);
      } catch (error) {
        return Future.error("Position error: " + error.toString());
      }
    }
    return l;
  }

  Future<String> searchMunicipalityGeo(double lat, double lon) async {
    double testlat = 59.911491;
    double testlon = 10.757933;
    String searchString = "https://ws.geonorge.no/adresser/v1/punktsok?" +
        "lon=" +
        testlon.toString() +
        "&" +
        "lat=" +
        testlat.toString() +
        "&koordsys=4258&treffPerSide=1&radius=1000&side=0&asciiKompatibel=true&utkoordsys=4258";

    http.Response response = await http.get(searchString);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['adresser'];
      if (list.isNotEmpty) {
        return list.first['kommunenummer'];
      }
    }
    return null;
  }
}
