import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/services/weather_services.dart';

class SearchPage extends StatelessWidget {
  String? cityName;
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  SearchPage({this.updateUi});

  VoidCallback? updateUi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search a City',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: searchController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'please enter a city to preview weather detail ';
              } else {
                return null;
              }
            },
            style: TextStyle(color: Colors.black),
            onChanged: (data) {
              cityName = data;
            },
            onFieldSubmitted: (data) async {
              if (formKey.currentState!.validate()) {
                cityName = data;
                WeatherService service = WeatherService();
                WeatherModel? weather =
                    await service.getWeather(cityName: cityName!);
                Provider.of<WeatherProvider>(context, listen: false)
                    .weatherData = weather;
                Provider.of<WeatherProvider>(context, listen: false).cityName =
                    cityName;
                // updateUi!();
                Navigator.pop(context);
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 16.0,
              ),
              suffixIcon: GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    WeatherService service = WeatherService();
                    WeatherModel? weather =
                        await service.getWeather(cityName: cityName!);
                    Provider.of<WeatherProvider>(context, listen: false)
                        .weatherData = weather;
                    Provider.of<WeatherProvider>(context, listen: false)
                        .cityName = cityName;
                    Navigator.pop(context);
                  } else {
                    return null;
                  }
                },
                child: Icon(
                  Icons.search,
                  size: 30.0,
                ),
              ),
              labelText: "Search",
              hintText: 'Enter City Name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ),
      ),
    );
  }
}
