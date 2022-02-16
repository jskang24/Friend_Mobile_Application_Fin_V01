import 'package:flutter/material.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/app/routes.dart';
import 'package:friend_mobile/ui/splash_screen/splash_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Friend App",
      initialRoute: SplashScreen.route,
      onGenerateRoute: generateRoute,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppTheme.secondaryColor,
        ),
        highlightColor: Colors.transparent,
        splashColor: AppTheme.primaryColor.withOpacity(0.3),
        splashFactory: InkRipple.splashFactory,
        primarySwatch: createMaterialColor(AppTheme.primaryColor),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "SFPro",
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  // ignore: avoid_function_literals_in_foreach_calls
  strengths.forEach((double strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
