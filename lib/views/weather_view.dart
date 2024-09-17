import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secure/weather_api.dart';
import 'package:weather_app/views/additional_item.dart';
import 'package:weather_app/views/weather_forecast_item.dart';
import 'package:http/http.dart' as http;


class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late Future<List<Map<String, dynamic>>>  weather;
  
  Future<Map<String, dynamic>> getWeatherData(
    final String option,
    final String location,
    final String units,
  ) async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/$option?q=$location&units=$units&appid=$apiKey",
        ),
      );
      if (res.statusCode != 200) {
        throw "An unexpeced error occured!";
      }
      return jsonDecode(res.body);
    } catch (e) {
      throw "An unexpeced error occured!";
    }
  }

  Future<List<Map<String, dynamic>>> getCurrentWeather() async {
    final currentWeather = await getWeatherData(
      "weather",
      "Hanoi,vn",
      "metric",
    );
    final hourlyForcast = await getWeatherData(
      "forecast",
      "Hanoi,vn",
      "metric",
    );
    return [currentWeather, hourlyForcast];
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final data = snapshot.data!;

              // current weather data
              final currentWeatherData = data[0];
              final currentWeatherState = data[0]["weather"][0]["main"];

              // forecast data
              final weatherForecast = data[1]["list"];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 230,
                        width: double.infinity,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          color: const Color.fromARGB(255, 41, 41, 41),
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${currentWeatherData["main"]["temp"]}°C",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  currentWeatherState == "Rain"
                                      ? const HugeIcon(
                                          icon: HugeIcons
                                              .strokeRoundedCloudAngledRainZap,
                                          color: Colors.white,
                                          size: 64,
                                        )
                                      : currentWeatherState == "Clouds"
                                          ? const HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedCloud,
                                              color: Colors.white,
                                              size: 64,
                                            )
                                          : const HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedSun03,
                                              color: Colors.white,
                                              size: 64,
                                            ),
                                  Text(
                                    currentWeatherState,
                                    style: const TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...weatherForecast.take(5).map<Widget>((forecast) {
                              return WeatherForecastItem(
                                time: DateFormat.j()
                                    .format(DateTime.parse(forecast["dt_txt"])),
                                weatherState: forecast["weather"][0]["main"],
                                value: "${forecast['main']['temp']} °C",
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Additional Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInformationItem(
                            icon: Icons.water_drop,
                            lable: "Humidity",
                            value: currentWeatherData["main"]["humidity"]
                                .toString(),
                          ),
                          AdditionalInformationItem(
                            icon: Icons.air,
                            lable: "Wind Speed",
                            value:
                                currentWeatherData["wind"]["speed"].toString(),
                          ),
                          AdditionalInformationItem(
                            icon: Icons.beach_access,
                            lable: "Pressure",
                            value: currentWeatherData["main"]["pressure"]
                                .toString(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
          }
        },
      ),
    );
  }
}
