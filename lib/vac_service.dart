import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_scraper/web_scraper.dart';

class VaccineService {
  Future<Map> getVaccinationCounts(String id) async {
    Map<String, int> counts = {};

    List<dynamic> l = await getVaccineAPI(id);

    for (int i = 1; i < l.length; i++) {
      counts[l[i][0]] = l[i][1];
    }
    return counts;
  }

  Future<List<dynamic>> getVaccineAPI(String id) async {
    Uri uri = Uri.parse("https://www.fhi.no/api/chartdata/api/" + id);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error: " + response.statusCode.toString());
      return null;
    }
  }

  Future<Map<String, String>> virusVariantScrape(int variantType) async {
    final webScraper = WebScraper('https://www.fhi.no');
    if (await webScraper.loadWebPage(
        '/sv/smittsomme-sykdommer/corona/statistikk-over-tilfeller-av-koronavirusvarianter/')) {
      String webPage = webScraper.getPageContent();

      String table1 = webPage.substring(webPage.indexOf('"data":{"csv":'));
      String table1x = table1
          .substring(table1.indexOf('\\n') + 2,
              table1.indexOf('","googleSpreadsheetKey'))
          .replaceAll('\\n', ';');
      String table2 = table1.substring(200);
      table2 = table2.substring(table2.indexOf('"data":{"csv":'));
      String table2x = table2
          .substring(table2.indexOf('\\n') + 2,
              table2.indexOf('","googleSpreadsheetKey'))
          .replaceAll('\\n', ';');

      var list1 = table1x.split(';');
      var list2 = table2x.split(';');

      Map<String, String> engCounts = {};
      for (int i = 0; i < list1.length - 2; i += 3)
        engCounts[list1[i]] = list1[i + 1];

      Map<String, String> saCounts = {};
      for (int i = 0; i < list2.length - 2; i += 3)
        saCounts[list2[i]] = list2[i + 1];

      switch (variantType) {
        case 0:
          return engCounts;
          break;
        case 1:
          return saCounts;
          break;
      }
    }
    return null;
  }
}
