Exchange Rate App
This is a simple Flutter app that fetches exchange rates from an API and displays them on the screen.

Getting Started
To get started with the app, clone the repository and run the following command to install the dependencies:
flutter pub get

Running the App
To run the app, use the following command:
flutter run

Running the Unit Tests
To run the unit tests, use the following command:
flutter test

Overview of the Codebase
The codebase is organized into the following directories:

lib: Contains the source code for the app.
test: Contains the unit test for the app.

App Architecture
The app follows the Model-View-Controller (MVC) architecture pattern.
The ExchangeRate class represents a single exchange rate.
The ExchangeRateApiService class is responsible for fetching exchange rates from the API.
The ExchangeRateController class is responsible for managing the exchange rate data and state.
The ExchangeRatePage widget is responsible for displaying the exchange rate data on the screen.

Unit Test
The unit test are located in the test directory and are organized into the following files:
The unit test use the flutter_test and mockito packages to test the functionality of the app.


Dependencies
The app uses the following dependencies:
flutter: The Flutter SDK.
getx: A package for implementing reactive state management.
top_snackbar_flutter: A package for displaying snackbars on the screen.
pull_to_refresh: A package for implementing pull-to-refresh functionality.
nb_utils: A package for implementing utility functions.
intl: A package for internationalization and localization.
http: A package for making HTTP requests.
loading_animations: A package for displaying loading animations.
mockito: A library for creating mock objects for testing.


Conclusion
That's it! You should now have a good understanding of how the app is structured and how to run theunit tests. If you have any questions or run into any issues, feel free to reach out.