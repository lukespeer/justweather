class WeatherData {
  final String location;
  final String region;
  final String date;
  final String sunrise;
  final String sunset;

  final int temperature;
  final String condition;

  final int high;
  final int low;

  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  final int humidity;
  final String wind;
  final String visibility;

  const WeatherData({
    required this.location,
    required this.region,
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.temperature,
    required this.condition,
    required this.high,
    required this.low,
    required this.hourly,
    required this.daily,
    required this.humidity,
    required this.wind,
    required this.visibility,
  });
}

class HourlyWeather {
  final String time;
  final int temperature;
  final String condition;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.condition,
  });
}

class DailyWeather {
  final String day;
  final String condition;
  final int low;
  final int high;

  const DailyWeather({
    required this.day,
    required this.condition,
    required this.low,
    required this.high,
  });
}
