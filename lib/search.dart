import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location.dart';
import 'loc_util.dart';

class SearchDialog extends StatefulWidget {
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final FocusNode _focusNode = FocusNode();
  final editController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  LocationUtil locUtil = LocationUtil();
  bool _needsScroll = false;
  List<Location> locations;
  bool _locationsLoaded = false;
  bool municipality = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
    loadLocations();
  }

  void loadLocations() async {
    _locationsLoaded = false;
    locations = await locUtil.loadLocations();
    _locationsLoaded = true;
    _needsScroll = true;
    setState(() {});
  }

  Future<void> saveLocationsExit(BuildContext context) async {
    await locUtil.saveRenumberLocations(locations);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      _needsScroll = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Søk kommune"),
          backgroundColor: Colors.grey,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              saveLocationsExit(context);
            },
          ),
        ),
        body: searchWindow(context));
  }

  inputDialog(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 200.0),
            child: SimpleDialog(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                elevation: 4,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  ),
                  searchWindow(context),
                ])));
  }

  Widget searchWindow(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: _locationsLoaded
              ? locations.length > 0
                  ? _buildLocationList(locations)
                  : Container()
              : _buildLoadingScreen()),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Søk kommunenavn: ',
            style: TextStyle(fontSize: 17.0),
          ),
          Checkbox(
            value: municipality,
            onChanged: (bool value) {
              setState(() {
                municipality = value;
              });
            },
          ),
        ],
      ),
      Container(
          padding: EdgeInsets.all(15),
          child: TextField(
            focusNode: _focusNode,
            controller: editController,
            autofocus: true,
            showCursor: true,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 3.0),
                ),
                border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(8.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    )),
                hintText: 'Søk adresse (gate by osv.)'),
          )),
      InkWell(
        child: Container(
          width: 100,
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(
            "Søk",
            style: TextStyle(color: Colors.white, fontSize: 25.0),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
          searchMunicipality(editController.text, municipality)
            ..then((loc) => addLocation(loc));
        },
      ),
      Container(height: 60)
    ]);
  }

  void addLocation(loc) async {
    if (loc != null) {
      locations.add(Location(
          id: "loc" + (locations.length + 1).toString(),
          name: loc.name,
          knummer: loc.knummer,
          lat: loc.lat,
          lon: loc.lon,
          reportedCases: 0,
          firstVaccine: 0,
          secondVaccine: 9));
      setState(() {});
    }
  }

  Widget _buildLocationList(locations) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          leading: Icon(Icons.house),
          title: Text(locations[index].name),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                locations.remove(locations[index]);
              });
            },
          ),
          onTap: () {
            editController.text = locations[index].name;
          },
        ));
      },
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

  Future<Location> searchMunicipality(query, bool municipality) async {
    List<Location> searchResult = [];

    String searchString;

    if (!municipality)
      searchString = "https://ws.geonorge.no/adresser/v1/sok?sok=";
    else
      searchString = "https://ws.geonorge.no/adresser/v1/sok?kommunenavn=";

    searchString += Uri.encodeComponent(query) +
        "&treffPerSide=1&utkoordsys=4258&asciiKompatibel=true&side=0";

    http.Response response = await http.get(searchString);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['adresser'];
      if (list.isNotEmpty) {
        for (var element in list) {
          searchResult.add(Location(
              id: list.length.toString(),
              name: element['kommunenavn'],
              knummer: element['kommunenummer'],
              lat: element['representasjonspunkt']['lat'],
              lon: element['representasjonspunkt']['lon']));
        }
        editController.text = "";
        if (locationExists(searchResult[0]))
          await alert("Finnes", "${searchResult[0].name}");
        else
          return searchResult[0];
      } else
        await alert("Ingen treff", "Prøv igjen");
    } else
      await alert("Feil", "Prøv igjen");
    editController.text = "";
    return null;
  }

  bool locationExists(Location s) {
    var existingItem = locations.firstWhere(
        (itemToCheck) => itemToCheck.name == s.name,
        orElse: () => null);
    if (existingItem != null)
      return true;
    else
      return false;
  }

  Future<dynamic> alert(String title, String content) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _scrollToEnd() async {
    if (_scrollController.hasClients)
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
