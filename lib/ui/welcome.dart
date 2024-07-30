import 'package:flutter/material.dart';
import 'package:project2/services/locaion_services.dart';
import 'package:project2/ui/home.dart';
import 'package:project2/ui/select_cities.dart';
import 'package:project2/widgets/typing_effect.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  void showErrorMessage(String errorMessage){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18
              ),

            )
          )
        );
      }
    );
  }
  
  void route(String location){
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => Home(location: location))
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.deepPurple.shade300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: TypingEffect(
                  color: Color.fromARGB(255, 119, 175, 231),
                  size: 50,
                  text: 'Welcome',
                  repeat: true,
                  time1: 200,
                  cursor: '|',
                  time2: 10000000
                )
              ),
              const SizedBox(height: 20,),
              Image.asset('lib/assets/get-started.png'),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                icon: const Icon(Icons.search_rounded),
                onPressed: () async {
                  showDialog(context: context, builder: (context){
                    return const Center(
                      child: CircularProgressIndicator()
                    ); 
                  });
                  try {
                    String? location = await getCityName();
                    if(location == null){
                      if(mounted){
                        Navigator.pop(context);
                      }
                      showErrorMessage('Error occured. Try again later.');
                    }
                    if(location!.split(' ').length > 1){
                      if(mounted){
                        Navigator.pop(context);
                      }
                      showErrorMessage(location);
                    } 
                    if(mounted){
                      Navigator.pop(context);
                    }
                    route(location);
                  } catch (e) {
                    if(mounted){
                      Navigator.pop(context);
                    }
                    showErrorMessage('$e');
                  }
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color.fromARGB(255, 47, 143, 207).withOpacity(0.8);
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
                label: const Text(
                  'Check my location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ) 
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: (){
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const SelectCities())
                  );
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color.fromARGB(255, 47, 143, 207).withOpacity(0.8);
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
                label: const Text(
                  'Select locations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ) ,
              )
            ]
          )
        )
      )
    );
  }
}