import 'package:shared_preferences/shared_preferences.dart';
import 'location.dart';
import 'dart:convert';
import 'vac_service.dart';

class LocationUtil {
  Future<List<Location>> loadLocations([Map<String, int> vaccines]) async {
    SharedPreferences locPref = await SharedPreferences.getInstance();
    int entries = locPref.getInt("ENTRIES");
    if (entries == null) entries = 0;

    List<Location> locations = [];
    Map<String, int> reportedCases =
        await VaccineService().getVaccinationCounts("90151");
    Map<String, int> firstVaccines =
        await VaccineService().getVaccinationCounts("99101");
    Map<String, int> secondVaccines =
        await VaccineService().getVaccinationCounts("99085");

    for (int i = 0; i < entries; i++) {
      Location l = loadLocation(locPref, locations, i);
      if (l != null) {
        if (l.reportedCases != reportedCases[l.knummer] ||
            l.firstVaccine != firstVaccines[l.knummer] ||
            l.secondVaccine != secondVaccines[l.knummer]) l.changed = true;
        l.reportedCases = reportedCases[l.knummer];
        l.firstVaccine = firstVaccines[l.knummer];
        l.secondVaccine = secondVaccines[l.knummer];
        locations.add(l);
      }
    }
    // SaveRenumber because we may have added updated data
    await saveRenumberLocations(locations);
    return locations;
  }

  Location loadLocation(
      SharedPreferences locPref, List<Location> locations, int id) {
    String lString = locPref.getString('loc' + id.toString());
    if (lString != null) {
      Map locMap = jsonDecode(locPref.getString('loc' + id.toString()));
      Location loc = Location.fromJson(locMap);
      return loc;
    }
    return null;
  }

  Future<void> saveRenumberLocations(List<Location> locations) async {
    SharedPreferences locPref = await SharedPreferences.getInstance();
    locPref.clear();
    locPref.setInt("ENTRIES", locations.length);
    for (int i = 0; i < locations.length; i++) {
      String id = "loc" + i.toString();
      Location l = locations[i];
      Location storeLoc = Location(
          id: id,
          name: l.name,
          knummer: l.knummer,
          lat: l.lat,
          lon: l.lon,
          reportedCases: l.reportedCases,
          firstVaccine: l.firstVaccine,
          secondVaccine: l.secondVaccine);
      String loc = jsonEncode(storeLoc.toJson());
      locPref.setString(id, loc);
    }
  }
}
