import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/services/weather_services.dart';

class HomePage extends StatelessWidget {
  final CurrentWeather currentWeather;
  const HomePage({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                                currentWeather.name,
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
                                    currentWeather.condition.text,
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
                                      '${currentWeather.temp}˚C',
                                      style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Image.network(
                                    currentWeather.condition.icon,
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
                          child: Icon(Icons.menu_rounded, color: Colors.white),
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
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search here',
                                ),
                                cursorColor: Colors.grey.shade800,
                                onChanged: (value) async {
                                  await WeatherServices().getAutoCompleteResult(
                                    value,
                                  );
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
                SizedBox(
                  height: 136,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '05.00 AM',
                                  style: TextStyle(
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.cloud_queue,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                Text(
                                  '29˚',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade900,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
