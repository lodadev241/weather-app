import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;

  const AdditionalInformationItem({
    super.key,
    required this.icon,
    required this.lable,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: 34,
          ),
          Text(
            lable,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
