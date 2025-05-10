import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/Cubits/get_current_weather_cubit/get_weather_cubit.dart';

class Search_TextField extends StatelessWidget {
  const Search_TextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: TextField(
          onSubmitted: (value) async {
            var getWeatherCubit = BlocProvider.of<GetWeatherCubit>(context);
            getWeatherCubit.getWeather(cityName: value);

            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 27, horizontal: 10),
            label: Text('Search'),
            hintText: "Enter City Name",
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
