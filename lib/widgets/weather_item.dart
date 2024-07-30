import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WeatherItem extends StatelessWidget {
  final String text, unit, imageUrl, value;
  List<String> words = [];

  WeatherItem({super.key, required this.value, required this.text, required this.unit, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    words = text.split(" ");
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Text(
            text, 
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8,),
          Container(
            padding: const EdgeInsets.all(10),
            height: 75,
            width: 75,
            decoration: const BoxDecoration(
              color: Color(0xffE0E8F8),
              borderRadius: BorderRadius.all(Radius.circular(15)) 
            ),
            child: Image.asset(imageUrl),
          ),
          const SizedBox(height: 8,),
          Text(
            value.toString() + unit,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54
            ),  
          )
        ],
      ),
    );
  }
}