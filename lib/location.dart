class Location with Comparable<Location> {
  final String id;
  final String name;
  final String knummer;
  final double lat;
  final double lon;
  int reportedCases;
  int firstVaccine;
  int secondVaccine;
  bool changed = false;

  Location(
      {this.id,
      this.name,
      this.knummer,
      this.lat,
      this.lon,
      this.reportedCases,
      this.firstVaccine,
      this.secondVaccine});

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
        id: parsedJson['id'] ?? "",
        name: parsedJson['name'] ?? "",
        knummer: parsedJson['knummer'] ?? "",
        lat: parsedJson['lat'] ?? 0,
        lon: parsedJson['lon'] ?? 0,
        reportedCases: parsedJson['reportedCases'],
        firstVaccine: parsedJson['firstVaccine'],
        secondVaccine: parsedJson['secondVaccine']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "knummer": this.knummer,
      "lat": this.lat,
      "lon": this.lon,
      "reportedCases": this.reportedCases,
      "firstVaccine": this.firstVaccine,
      "secondVaccine": this.secondVaccine
    };
  }

  @override
  String toString() {
    return id +
        " " +
        name +
        " " +
        knummer +
        " " +
        lat.toString() +
        " " +
        lon.toString() +
        " " +
        reportedCases.toString() +
        " " +
        firstVaccine.toString() +
        " " +
        secondVaccine.toString();
  }

  @override
  int compareTo(Location other) => (name).compareTo(other.name);
}
