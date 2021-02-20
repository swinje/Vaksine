import 'package:flutter/material.dart';
import 'vac_service.dart';
import 'mutation_chart.dart';

class VariantsScreen extends StatelessWidget {
  final String title;
  final int variantType;
  const VariantsScreen(this.title, this.variantType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.grey,
        ),
        body: Column(children: [
          /*headerCard(), */ Flexible(child: variantScreen(context))
        ]));
  }

  Widget variantScreen(BuildContext context) {
    return FutureBuilder<Map>(
        future: VaccineService().virusVariantScrape(variantType),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              /*Container(
                  height: 400,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        String key = snapshot.data.keys.elementAt(index);
                        return Column(
                          children: <Widget>[
                            countCard(key, snapshot.data[key])
                          ],
                        );
                      })),*/
              Container(
                  height: MediaQuery.of(context).size.height - 200,
                  margin:
                      EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
                  child: MutationChart(title, snapshot.data))
            ]);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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
                      width: 140,
                      child: Text("Uke",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 60,
                      child: Text("Antall",
                          style: TextStyle(fontSize: 16, color: Colors.white)))
                ]))));
  }

  Widget countCard(String week, String count) {
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
                      width: 120,
                      child: Text(week,
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                  Container(
                      alignment: Alignment.centerRight,
                      width: 50,
                      child: Text(count,
                          style: TextStyle(fontSize: 16, color: Colors.white)))
                ]))));
  }
}
