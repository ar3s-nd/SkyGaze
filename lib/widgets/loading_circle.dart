import 'package:flutter/material.dart';
import 'package:project2/widgets/typing_effect.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TypingEffect(
                text: 'SkyGazing...', 
                size: 18, 
                color: Colors.black54,
                time1: 75,
                time2: 1,
                repeat: true,
                cursor: '',
              )
            ],
          )
        ],
      )
    );
  }
}