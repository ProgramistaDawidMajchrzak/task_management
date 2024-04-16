import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:task_management_go_online/geo.dart';

void main() {
  runApp(const GeolocatorWidget());
}

class GeolocatorWidget extends StatefulWidget {
  const GeolocatorWidget({super.key});

  @override
  State<GeolocatorWidget> createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;

  double? latitude;
  double? longitude;
  String? info;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text('$longitude'),
        // Text('$latitude'),
        SizedBox(
          //decoration: const BoxDecoration(color: Colors.lightBlue),
          height: MediaQuery.of(context).size.height * 0.2,
          child: (latitude != null && longitude != null)
              ? FutureBuilder<Map<String, dynamic>>(
                  future: fetchWeather(latitude!, longitude!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final weatherData = snapshot.data;
                      final cityName = weatherData!['name'];
                      final weatherIcon = weatherData['weather'][0]['icon'];
                      final temperature = weatherData['main']['temp'];
                      final weatherDescription =
                          weatherData['weather'][0]['description'];
                      DateTime now = DateTime.now();
                      DateFormat dateFormat = DateFormat('EEEE, dd.MM.yyyy');
                      String formattedDate = dateFormat.format(now);
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Text(info!),
                            Row(
                              children: [
                                const SizedBox(width: 12.0),
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFF3787EB),
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              children: [
                                const SizedBox(width: 12.0),
                                const Icon(
                                  Icons.room,
                                  color: Color(0xFF3787EB),
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  cityName,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.network(
                                    'https://openweathermap.org/img/w/$weatherIcon.png'),
                                Text(
                                  '$temperature °C, $weatherDescription',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    if (!mounted) return;
    final position = await _geolocatorPlatform.getCurrentPosition();
    setState(() {
      info = 'position enabled';
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        info = 'position not enabled 1';
      });
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        info = 'position not enabled 2';
      });
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          info = 'position not enabled 3';
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        info = 'position not enabled 4';
      });
      return false;
    }
    setState(() {
      info = 'position enabled 5';
    });
    return true;
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }
}
