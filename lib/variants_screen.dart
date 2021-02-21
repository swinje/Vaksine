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
        body: variantScreen());
  }

  Widget variantScreen() {
    return FutureBuilder<Map>(
        future: VaccineService().virusVariantScrape(variantType),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
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
}
