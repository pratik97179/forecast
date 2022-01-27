<p align="center">
  <img width="200" height="200" src="https://cdn-icons-png.flaticon.com/512/1163/1163712.png">
</p>

# Forecast
Beautiful flutter weather forecasting application. Entirely written in Dart and Flutter.

>**NOTE**: The app is still under development. Feel free to pull the code and contribute to make the app better.


## Platform
 Currently, the app is being developed for Android only. It will be made available soon for iOS as well.
 
## Features
* Minimal yet beatiful UI
* Current temperature, humidity, wind speed.
* Custom icons for each weather condition
* Beautifully animated transitions
* Provider package for state management

## Setup

#### API Key
>**NOTE**: You will need an API key for all the mentioned APIs, repectively, to work.
- Visit [Openweather](https://openweathermap.org/) & [Mapbox](https://www.mapbox.com/), create an account and retrieve the respective API keys.
- Replace all ```{YOUR_KEY}``` with the respective API keys in the ```api_constant.dart``` file.
 eg: ```static const OPENWEATHER_API_KEY = "{YOUR_KEY}";```
- ```flutter pub get```
- ```flutter run```

## Acknowledgment
- Icons: [Flaticon](https://www.flaticon.com/)
- Weather API: [OpenWeatherMap](https://openweathermap.org/)
- Geo-coding API: [Mapbox](https://www.mapbox.com/)