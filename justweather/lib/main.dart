// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:justweather/objects/locations.dart';
import 'package:justweather/widgets/weather_record.dart';
import 'package:justweather/widgets/add_location_dialog.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Location> locations = [
    Location(name: "Conway", latitude: 35.0887, longitude: -92.4421),
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
              showCitySearchDialog(context, (city) {
                setState(() {
                  locations.add(Location(name: city.name, latitude: city.latitude, longitude: city.longitude));
                });
              });
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
