import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeSeries {
  String week;
  String count;

  TimeSeries(
    this.week,
    this.count,
  );
}

class MutationChart extends StatelessWidget {
  final String title;
  final Map<String, String> timeseries;
  const MutationChart(this.title, this.timeseries);

  @override
  Widget build(BuildContext context) {
    List<TimeSeries> ts = timeseries.entries
        .map((entry) => TimeSeries(entry.key, entry.value))
        .toList();

    return charts.BarChart(
      _seriesList(ts, "Mutasjoner"),
      behaviors: [
        charts.ChartTitle('Uke',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
      animate: true,
      //barRendererDecorator: charts.BarLabelDecorator<String>(),
      //domainAxis: charts.OrdinalAxisSpec(),
    );
  }

  List<charts.Series<TimeSeries, String>> _seriesList(
      List<TimeSeries> measurements, String title) {
    return [
      charts.Series<TimeSeries, String>(
          id: 'Antall',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeries ts, _) => ts.week,
          measureFn: (TimeSeries ts, _) => int.parse(ts.count),
          data: measurements)
      //labelAccessorFn: (TimeSeries ts, _) => ts.count.toString())
    ];
  }
}
