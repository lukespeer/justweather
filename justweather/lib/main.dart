// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:justweather/objects/item.dart';
import 'package:justweather/widgets/to_do_items.dart';
import 'package:justweather/widgets/to_do_dialog.dart';
import 'package:justweather/objects/locations.dart';
import 'package:justweather/api/weather_service.dart';
import 'package:justweather/widgets/weather_record.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Location> locations = [
    Location(name: "Washington, D.C.", latitude: 38.8977, longitude: -77.0365),
    Location(name: "New York City", latitude: 40.7128, longitude: -74.0060),
    Location(name: "Los Angeles", latitude: 34.0522, longitude: -118.2437),
    Location(name: "Chicago", latitude: 41.8781, longitude: -87.6298),
    Location(name: "Houston", latitude: 29.7604, longitude: -95.3698),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Weather'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: locations.map((location) {
            return WeatherRecord(location: location);
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'To Do List',
    home: const ToDoList(),
    theme: ThemeData.dark(useMaterial3: true),
    debugShowCheckedModeBanner: false,
  ));
}
