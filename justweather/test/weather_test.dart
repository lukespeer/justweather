import 'package:flutter_test/flutter_test.dart';
import 'package:justweather/api/weather_service.dart';

void main()
{
  test('Weather API returns data', () async {
    final data = await getWeather(latitude: 38.8977, longitude: -77.0365);
    expect(data, isNotNull);
    expect(data.region, isNotEmpty);
    expect(data.visibility, isNotEmpty);
  });

  test('Weather API error on bad coords', () async {
    try {
      await getWeather(latitude: 999, longitude: 999);
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });
}