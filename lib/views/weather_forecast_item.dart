import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class WeatherForecastItem extends StatelessWidget {
  final String time;
  final String weatherState;
  final String value;

  const WeatherForecastItem({
    super.key,
    required this.time,
    required this.weatherState,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 120,
      child: Card(
        elevation: 6,
        color: const Color.fromARGB(255, 41, 41, 41),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            weatherState == "Rain"
                ? const HugeIcon(
                    icon: HugeIcons.strokeRoundedCloudAngledRainZap,
                    color: Colors.white,
                    size: 64,
                  )
                : weatherState == "Clouds"
                    ? const HugeIcon(
                        icon: HugeIcons.strokeRoundedCloud,
                        color: Colors.white,
                        size: 64,
                      )
                    : const HugeIcon(
                        icon: HugeIcons.strokeRoundedSun03,
                        color: Colors.white,
                        size: 64,
                      ),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
