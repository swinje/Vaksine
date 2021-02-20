import 'package:flutter/material.dart';
import 'location.dart';

class VaccineScreen extends StatelessWidget {
  final List<Location> locations;
  const VaccineScreen(this.locations);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(height: 10),
      Container(height: 80, child: headerCard()),
      Flexible(
          child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return locationCard(locations[index]);
              }))
    ]);
  }

  Widget headerCard() {
    return Card(
        color: Colors.red[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 120,
                      child: Text("Kommune",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 60,
                      child: Text("Covid",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 70,
                      child: Text("Første",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 50,
                      child: Text("Andre",
                          style: TextStyle(fontSize: 16, color: Colors.white)))
                ]))));
  }

  Widget locationCard(Location loc) {
    return Card(
        color: Colors.green[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ListTile(
                //leading:
                //Icon(Icons.location_city, color: Colors.white, size: 20),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 100,
                      child: Text(loc.name,
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  loc.changed ? Colors.pink : Colors.white))),
                  Container(
                      alignment: Alignment.centerRight,
                      width: 70,
                      child: Text(loc.reportedCases.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerRight,
                      width: 70,
                      child: Text(loc.firstVaccine.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerRight,
                      width: 70,
                      child: Text(loc.secondVaccine.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.white)))
                ]))));
  }
}
