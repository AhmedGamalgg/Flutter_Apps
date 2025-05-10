import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/Cubits/get_current_weather_cubit/get_weather_cubit.dart';
import 'package:myapp/Cubits/get_current_weather_cubit/get_weather_states.dart';
import 'package:myapp/Pages/search_page.dart';
import 'package:myapp/Widgets/country_widget.dart';
import 'package:myapp/Widgets/no_country_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ],
        title: Text(
          'Weather',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:
          BlocBuilder<GetWeatherCubit, WeatherState>(builder: (context, state) {
        if (state is NoWeatherState) {
          return const NoCountryWidget();
        } else if (state is WeatherLoadedState) {
          return CountryWidget(weatherModel: state.weatherModel);
        } else {
          //No City Found Handling
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Oops,City Not Found",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                  label: Text("Search Again!"),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
