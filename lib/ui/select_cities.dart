import 'package:flutter/material.dart';
import 'package:project2/models/city.dart';
import 'package:project2/services/locaion_services.dart';
import 'package:project2/ui/home.dart';

class SelectCities extends StatefulWidget {
  const SelectCities({super.key});

  @override
  State<SelectCities> createState() => _SelectCitiesState();
}

class _SelectCitiesState extends State<SelectCities> {
  bool selectAll = false;

  void route(String location){
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => Home(location: location,))
    );
  }

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
  
  @override
  Widget build(BuildContext context) {
    List<City> cities = City.citiesList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.citiesList.where((city) => city.isSelected == true).toList();
    Size size = MediaQuery.of(context).size;
    for(City city in cities){
      if(!city.isSelected){
        selectAll = false;
        break;
      }
      selectAll = true;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.shade400,
        title: Row(
          children: [
            GestureDetector(
              onTap:() {
                setState(() {
                  selectAll = !selectAll;
                  for (City city in cities){
                    city.isSelected = selectAll;
                  }
                });
              },
              child: Image.asset(
                selectAll? 
                  'lib/assets/checked.png': 
                  'lib/assets/unchecked.png',
                width: 30,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              '${selectedCities.length} selected',
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          ]
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                cities[index].isSelected = !cities[index].isSelected; 
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 20, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: size.height * .08,
              width: size.width,
              decoration: BoxDecoration(
                border: cities[index].isSelected? Border.all(
                  color: Colors.deepPurple.shade200,
                  width: 2,
                ): Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade100,
                    spreadRadius: .5,
                    blurRadius: 7,
                    offset: const Offset(0, 3)
                  )
                ]
              ),
              child: Row(
                children: [
                  Image.asset(
                    cities[index].isSelected? 
                      'lib/assets/checked.png': 
                      'lib/assets/unchecked.png',
                    width: 30,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    cities[index].city, 
                    style: TextStyle(
                      fontSize: 16,
                      color: cities[index].isSelected?  Colors.black: Colors.grey[600],
                    )
                  )
                ],
              )
            ),
          );
        }
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[400],
        child: const Icon(
          Icons.arrow_forward_rounded,
          size: 40,
          color: Colors.white,
        ),
        
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
      )    
    );
  }
}