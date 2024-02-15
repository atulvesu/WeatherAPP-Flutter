import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});

  Future<dynamic> getData() async {
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception while fetching data: $e');
      return null;
    }
  }
}
