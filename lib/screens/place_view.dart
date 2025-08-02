import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/models/astro_model.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/prediction_model.dart';
import 'package:weather_app/services/weather_services.dart';

import '../models/hourly_weather.dart';

class PlaceView extends StatefulWidget {
  final PredictionModel prediction;
  const PlaceView({super.key, required this.prediction});

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  late Future<CurrentWeather?> getCurrentWeather;
  late Future<List<HourlyWeather>> hourlyWeatherList;
  late Future<AstroModel?> astroModel;

  @override
  void initState() {
    super.initState();
    getCurrentWeather = WeatherServices().getCurrentWeather(
      widget.prediction.name,
    );
    hourlyWeatherList = WeatherServices().getHourlyWeather(
      widget.prediction.name,
    );
    astroModel = WeatherServices().getAstronomyData(widget.prediction.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 12),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: BackButton(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FutureBuilder(
                      future: getCurrentWeather,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return SizedBox(
                            height: 200,
                            child: Center(child: Text('Something went wrong')),
                          );
                        }

                        CurrentWeather currentWeather = snapshot.data!;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${currentWeather.temp} C˚',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.network(
                                  currentWeather.condition.icon,
                                  width: 40,
                                ),
                              ],
                            ),
                            Text(
                              currentWeather.condition.text,
                              style: TextStyle(color: Colors.grey.shade200),
                            ),
                            Text(
                              widget.prediction.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
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
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.grey.shade300,
                          child: ListView.builder(
                            itemCount: 10,
                            physics: NeverScrollableScrollPhysics(),

                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      final list = snapshot.data!
                          .where(
                            (element) =>
                                element.time.hour > DateTime.now().hour,
                          )
                          .toList();
                      return MediaQuery.removePadding(
                        context: context,

                        removeTop: true,
                        removeBottom: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final weather = list[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child: Image.network(
                                  weather.condition.icon,
                                  width: 30,
                                ),
                              ),
                              trailing: Text(
                                '${weather.temp} C˚',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              title: Text(weather.condition.text),
                              subtitle: Text(
                                DateFormat('hh:mm a').format(weather.time),
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
