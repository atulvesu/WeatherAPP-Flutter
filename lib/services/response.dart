import 'package:http/http.dart' as http;

class WeatherData {
  final String apiUrl =
      'https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22';

  Future<void> getData() async {
    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Weather data: ${response.body}');
      } else {
        print(
            'Failed to fetch weather data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }
}

// void main() {
//   WeatherData weather = WeatherData();
//   weather.getData();
// }
