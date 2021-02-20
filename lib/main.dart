import 'package:flutter/material.dart';
import 'package:vaksine/variants_screen.dart';
import 'search.dart';
import 'loc_util.dart';
import 'location.dart';
import 'vaccine_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.grey),
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  LocationUtil locUtil = LocationUtil();
  List<Location> locations;
  bool _locationsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _locationsLoaded = false;
    if (locations != null) locations.clear();
    locations = await locUtil.loadLocations();
    _locationsLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
          backgroundColor: Colors.red[50],
          appBar: AppBar(
              backgroundColor: Colors.green[400],
              title: Text('Vaksiner',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              centerTitle: true,
              toolbarHeight: 60.2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 50.0,
              leading: IconButton(
                icon: ImageIcon(AssetImage("assets/coronavirus.png"),
                    color: Colors.white),
                tooltip: 'Menu Icon',
                onPressed: () {
                  loadData();
                  setState(() {});
                },
              ),
              actions: <Widget>[
                _buildVariationButton(
                    "Engelsk mutasjon", "assets/united-kingdom.png", 30, 0),
                _buildVariationButton(
                    "Sør-Afrikansk mutasjon", "assets/south-africa.png", 30, 1),
                _buildSearchButton(Icons.settings, Colors.white, 28.0)
              ]),
          body: Column(children: [
            Flexible(
                child: _locationsLoaded
                    ? locations.length > 0
                        ? VaccineScreen(locations)
                        : Center(
                            child: Container(
                                width: 50,
                                height: 50,
                                child: _buildSearchButton(
                                    Icons.search, Colors.blue, 80.0)))
                    : _buildLoadingScreen()),
          ]))
    ]);
  }

  Widget _buildSearchButton(icon, color, size) {
    return IconButton(
        icon: Icon(
          icon,
          size: size,
          color: color,
        ),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchDialog()))
              .then((v) => loadData());
        });
  }

  Widget _buildVariationButton(String title, icon, double size, variationType) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VariantsScreen(title, variationType)));
      },
      child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Image.asset(icon, width: size)),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
