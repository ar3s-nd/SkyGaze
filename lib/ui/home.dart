import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project2/models/city.dart';
import 'package:project2/services/locaion_services.dart';
import 'package:project2/ui/select_cities.dart';
import 'package:project2/widgets/loading_circle.dart';
import 'package:project2/widgets/textfield.dart';
import 'package:project2/widgets/weather_item.dart';
import "package:weatherapi/weatherapi.dart";

class Home extends StatefulWidget {
  final String location;
  const Home({super.key, required this.location});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // get the cities and selected cities
  var selectedCities = City.getSelectedCities(); 
  String? location = 'London';
  List<String> cities = [];
  var date = 'Loading...';
  bool isLoading = true;

  WeatherRequest wr = WeatherRequest('72d6e424fa87422d94f120328242607');
  
  @override
  void initState() {
    super.initState();
    location = widget.location;
    fetchLocation();
  }

  void fetchLocation() async {
    cities.add(location!);
    cities.toSet().toList();
    fetchDetails(location!);
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

  Future<void> fetchDetails(String location) async {
    setState(() {
      isLoading = true;
    });

    try {
      ForecastWeather fw = await wr.getForecastWeatherByCityName(location);
      RealtimeWeather rw = await wr.getRealtimeWeatherByCityName(location);

      setState(() {
        // Assuming RealtimeWeather and ForecastWeather have these fields
        temp = rw.current.tempC.toString();
        maxTemp = fw.forecast[0].day.maxtempC.toString();
        minTemp = fw.forecast[0].day.mintempC.toString();
        humidity = rw.current.humidity.toString();
        windspeed = rw.current.windKph.toString();
        feelslike = rw.current.feelslikeC.toString();
        image =  fw.forecast[0].day.condition.icon!;
        text = fw.forecast[0].day.condition.text!;
        rain = fw.forecast[0].day.dailyChanceOfRain.toString();
        date = fw.forecast[0].date!;
      });

      for (City city in selectedCities) {
        if (!cities.contains(city.city)) {
          cities.add(city.city);
        }
      }

      if (!cities.contains(location)) {
        cities.add(location);
      }

      if(cities.last != 'Edit locations?'){
        if(cities.contains('Edit locations?')){
          cities.remove('Edit locations?');
        }
        cities.add('Edit locations?');
      }
    } catch (e) {
      showErrorMessage('$e');
    }

    setState(() {
      isLoading = false;
    });
  }

  String temp = '0', maxTemp = '0', minTemp = '0', humidity = '0', windspeed = '0', feelslike = '0', rain = '0';
  String image = '', text = '';

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.shade400,
        centerTitle: true,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [          
              const SizedBox(width: 1),
              Text(
                'SkyGaze',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold
                ),
              ),
              // location dropdown
              SizedBox(
                width: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/pin.png', width: 20,),
                      const SizedBox(width: 4,),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: location,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: cities.map((String location){
                            return DropdownMenuItem(
                              value: location,
                              child: Text(
                                location,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            );
                          }).toList(), 
                          onChanged: (String? newValue){
                            setState(() {
                              location = newValue!;
                              if(cities.contains(location)){
                                if(location == 'Edit locations?'){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SelectCities())
                                  );
                                } else {
                                  fetchDetails(location!);
                                }
                              }
                            });
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
      
      body: isLoading? 
      const LoadingCircle(): 
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                )
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16
                )
              ),
              const SizedBox(height: 20),
              Container(
                width: size.width,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade100,
                      spreadRadius: -12,
                      blurRadius: 10,
                      offset: const Offset(0, 25)
                    )
                  ]
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      left: 30,
                      child: image == ''?
                      const Text(''):
                      Image.network(
                        'https:$image',
                        width: 100,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Text(
                            'Error: $error',
                            style: const TextStyle(color: Colors.red),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: SizedBox(
                        width: 125,
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ),
                    Positioned( 
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              temp,
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient
                              )
                            ), 
                          ),
                          Text(
                            '°',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                          Text(
                            'C',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          )
                        ]
                      )
                    )
                  ],
                )
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherItem(
                    text: "Maximum\nTemperature",
                    value: maxTemp,
                    unit: '°C',
                    imageUrl: 'lib/assets/temp.png',
                  ),
                  WeatherItem(
                    text: "Minimum\nTemperature",
                    value: minTemp,
                    unit: '°C',
                    imageUrl: 'lib/assets/temp.png',
                  ),
                  WeatherItem(
                    text: "Feels\nLike",
                    value: feelslike,
                    unit: '°C',
                    imageUrl: 'lib/assets/temp.png',
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherItem(
                    text: "\nHumidity",
                    value: humidity,
                    unit: '%',
                    imageUrl: 'lib/assets/humidity.png',
                  ),
                  WeatherItem(
                    text: "Wind\nSpeed",
                    value: windspeed,
                    unit: 'km/h',
                    imageUrl: 'lib/assets/windspeed.png',
                  ),
                  WeatherItem(
                    text: "Chance\nof Rain",
                    value: rain,
                    unit: '%',
                    imageUrl: 'lib/assets/lightrain.png',
                  ),
                ]
              ),
            ],
          )
        ),
      ),
        
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.deepPurple[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.5),
        ),
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.pin_drop,
              fill: 0.1,
              color: Colors.deepPurple,
            ),
            onTap: findCurrentLocation,
            label: 'My Location',
          ),
          SpeedDialChild(
            child: SvgPicture.asset(
              'lib/assets/search.svg',
              color: Colors.deepPurple,
            ),
            label: 'Search Cities',
            onTap: searchLocation,
          ),
        ],
      ),
    );
  }

  void findCurrentLocation() async {
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator()
      );
    });
    try {
      String? userCity = await getCityName();
      if(userCity == null){
        if(mounted){
          Navigator.pop(context);
        }
        showErrorMessage('Error occured. Try again later.');
      }
      if(userCity!.split(' ').length > 1){
        if(mounted){
          Navigator.pop(context);
        }
        showErrorMessage(userCity);
      } 
      if(mounted){
        Navigator.pop(context);
      }
        if(!cities.contains(userCity)){
        cities.remove('Edit locations?');
        cities.add(userCity);
        cities.add('Edit locations?');
      } 
      location = userCity;
      fetchDetails(userCity);
    } catch (e) {
      if(mounted){
        Navigator.pop(context);
      }
      showErrorMessage('$e');
    }         
  }

  TextEditingController locationController = TextEditingController();
  searchLocation() => showDialog(context: context, builder: (context) => SingleChildScrollView(
    child: AlertDialog(
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'lib/assets/cross_icon.svg',
                ),
                onPressed: () {
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                }
              ),
              // const SizedBox(width: 5),
              const Text(
                'Search for a city',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20
                )
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Textfield(controller: locationController),
          const SizedBox(height: 5,),
          ElevatedButton(
            onPressed: () async {
              String newLocation = locationController.text;
              if(mounted){
                Navigator.pop(context);
              }
              try {
                newLocation = newLocation[0].toUpperCase() + newLocation.substring(1);
                RealtimeWeather rw = await wr.getRealtimeWeatherByCityName(newLocation);
                location = newLocation;
                locationController.text = '';
                fetchLocation();
              } catch (e) {
                showErrorMessage('Please enter valid city name.');
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
            child: const Text(
              'Search',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ) 
          )
        ],
      ),
    ),
  ));
}