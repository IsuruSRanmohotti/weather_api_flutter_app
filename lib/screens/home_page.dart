import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/models/astro_model.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/prediction_model.dart';
import 'package:weather_app/screens/place_view.dart';
import 'package:weather_app/services/weather_services.dart';

import '../models/hourly_weather.dart';

class HomePage extends StatefulWidget {
  final CurrentWeather currentWeather;
  const HomePage({super.key, required this.currentWeather});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<HourlyWeather>> hourlyWeatherList;
  late Future<AstroModel?> astroModel;

  TextEditingController queryController = TextEditingController();
  List<PredictionModel> predictions = [];

  @override
  void initState() {
    super.initState();
    hourlyWeatherList = WeatherServices().getHourlyWeather(
      widget.currentWeather.name,
    );
    astroModel = WeatherServices().getAstronomyData(widget.currentWeather.name);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Stack(
                      children: [
                        ClipRect(
                          child: Lottie.asset(
                            'assets/lotties/rainy_nights.json',
                            width: double.infinity,
                            height: 350,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.currentWeather.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.currentWeather.condition.text,
                                      style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 2,
                                      ),
                                      child: Text(
                                        '${widget.currentWeather.temp}˚C',
                                        style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Image.network(
                                      widget.currentWeather.condition.icon,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black45,
                            child: Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Weather App',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              WeatherServices().getCurrentWeather('Colombo');
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: TextField(
                                  controller: queryController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search here',
                                  ),
                                  cursorColor: Colors.grey.shade800,
                                  onChanged: (value) async {
                                    if (value.isNotEmpty) {
                                      predictions = await WeatherServices()
                                          .getAutoCompleteResult(value);
                                    } else {
                                      predictions.clear();
                                    }

                                    setState(() {});
                                    // setState is removed since this is now StatelessWidget
                                  },
                                ),
                              ),
                              Icon(Icons.search, color: Colors.grey.shade800),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (predictions.isNotEmpty && queryController.text.isNotEmpty)
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(predictions[index].name),
                      subtitle: Text(predictions[index].country),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlaceView(prediction: predictions[index]),
                          ),
                        );
                        setState(() {
                          queryController.clear();
                        });
                      },
                    );
                  },
                ),
              ),

            LottieBuilder.asset('assets/lotties/sunset.json'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder(
                future: astroModel,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey,

                              highlightColor: Colors.grey.shade500,
                              child: Container(
                                width: 100,
                                height: 20,
                                color: Colors.grey,
                              ),
                            ),
                            Text('Sunrise'),
                          ],
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,

                              highlightColor: Colors.grey.shade500,
                              child: Container(
                                width: 100,
                                height: 20,
                                color: Colors.grey,
                              ),
                            ),
                            Text('Sunset'),
                          ],
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return Text('Something went wrong');
                  }

                  final astroModel = snapshot.data!;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            astroModel.sunrise,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('Sunrise'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            astroModel.sunset,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('Sunset'),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 12),
                    child: Text(
                      'Hourly Weather Forecast',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: hourlyWeatherList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(5, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.grey.shade500,
                                  child: Container(
                                    width: 100,
                                    height: 136,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.data!.isEmpty) {
                        return Text('No Data');
                      }
                      List<HourlyWeather> hourlyWeather = snapshot.data!
                          .where(
                            (element) =>
                                element.time.hour > DateTime.now().hour,
                          )
                          .toList();
                      return SizedBox(
                        height: 136,
                        child: ListView.builder(
                          itemCount: hourlyWeather.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: GestureDetector(
                                  onTap: () {
                                  
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Image.network(
                                            hourlyWeather[index].condition.icon,
                                            width: 40,
                                          ),
                                        ),
                                        Text(
                                          '${hourlyWeather[index].temp}˚',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade900,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          DateFormat(
                                            'hh.mm a',
                                          ).format(hourlyWeather[index].time),
                                          style: TextStyle(
                                            color: Colors.grey.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
