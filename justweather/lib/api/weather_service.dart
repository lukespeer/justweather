import '../objects/weather_data.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const String userAgent = 'JustWeather/1.0';

Future<WeatherData> getWeather({
    required double latitude,
    required double longitude
  }) async {
  final pointsUrl = Uri.parse(
    'https://api.weather.gov/points/'
    '$latitude,$longitude',
  );

  final pointsResponse = await http.get(
    pointsUrl,
    headers: {'User-Agent': userAgent, 'Accept': 'application/geo+json'},
  );

  if (pointsResponse.statusCode != 200) {
    throw Exception(
      'Failed to find weather location '
      '(${pointsResponse.statusCode})',
    );
  }

  final points = jsonDecode(pointsResponse.body);

  final properties = points['properties'];

  final forecastUrl = Uri.parse(properties['forecast']);

  final hourlyUrl = Uri.parse(properties['forecastHourly']);

  final forecastResponse = await http.get(
    forecastUrl,

    headers: {'User-Agent': userAgent, 'Accept': 'application/geo+json'},
  );

  if (forecastResponse.statusCode != 200) {
    throw Exception(
      'Failed to retrieve forecast '
      '(${forecastResponse.statusCode})',
    );
  }

  final hourlyResponse = await http.get(
    hourlyUrl,

    headers: {'User-Agent': userAgent, 'Accept': 'application/geo+json'},
  );

  if (hourlyResponse.statusCode != 200) {
    throw Exception(
      'Failed to retrieve hourly forecast '
      '(${hourlyResponse.statusCode})',
    );
  }

  final forecastJson = jsonDecode(forecastResponse.body);

  final hourlyJson = jsonDecode(hourlyResponse.body);

  final periods = forecastJson['properties']['periods'];

  final hourlyPeriods = hourlyJson['properties']['periods'];

  final firstPeriod = periods[0];

  final hourly = hourlyPeriods.take(12).map<HourlyWeather>((period) {
    final date = DateTime.parse(period['startTime']);

    return HourlyWeather(
      time: formatTime(date),
      temperature: period['temperature'],
      condition: period['shortForecast'],
    );
  }).toList();

  final daily = <DailyWeather>[];

  for (int i = 0; i < periods.length && i < 14; i += 2) 
  {
    final period = periods[i];

    if (period['isDaytime'] != true)
     {
      continue;
    }

    final nightIndex = i + 1;

    int? low;

    if (nightIndex < periods.length) 
    {
      low = periods[nightIndex]['temperature'];
    }

    daily.add(
      DailyWeather(
        day: formatDay(DateTime.parse(period['startTime'])),
        condition: period['shortForecast'],
        low: low ?? period['temperature'],
        high: period['temperature'],
      ),
    );

    if (daily.length >= 7) {
      break;
    }
  }

  return WeatherData(
    location:
        properties['relativeLocation']?['properties']['city'] ?? 'Unknown',
    region:
        properties['relativeLocation']?['properties']['state'] ?? 'Unknown',
    sunrise: formatIsoTime(properties['astronomicalData']?['sunrise']),
    sunset: formatIsoTime(properties['astronomicalData']?['sunset']),
    date: formatDate(DateTime.parse(firstPeriod['startTime'])),
    temperature: hourly.first.temperature,
    condition: hourly.first.condition,
    high: daily.isNotEmpty ? daily.first.high : firstPeriod['temperature'],
    low: daily.isNotEmpty ? daily.first.low : firstPeriod['temperature'],
    hourly: hourly,
    daily: daily,
    humidity: 0,
    wind: firstPeriod['windSpeed'] ?? 'Unknown',
    visibility: '—',
  );
}

String formatTime(DateTime date) {
  final hour = date.hour;

  final displayHour = hour == 0
      ? 12
      : hour > 12
      ? hour - 12
      : hour;

  final suffix = hour >= 12 ? 'PM' : 'AM';

  return '$displayHour $suffix';
}

String formatIsoTime(String? value) {
  if (value == null) {
    return '--';
  }

  final match = RegExp(r'T(\d{2}):(\d{2})').firstMatch(value);

  if (match == null) {
    return '--';
  }

  final hour = int.parse(match.group(1)!);
  final minute = match.group(2)!;
  final displayHour = hour == 0
      ? 12
      : hour > 12
      ? hour - 12
      : hour;
  final suffix = hour >= 12 ? 'PM' : 'AM';

  return '$displayHour:$minute $suffix';
}

String formatDate(DateTime date)
{
  return '${weekdays[date.weekday - 1]}, '
      '${months[date.month - 1]} ${date.day}';
}

String formatDay(DateTime date) 
{
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return weekdays[date.weekday - 1];
}
