import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionary_walls/screens/download/download_screen.dart';
import 'package:visionary_walls/screens/home/home_screen.dart';
import 'package:visionary_walls/screens/view/view_screen.dart';
import 'package:visionary_walls/themes/dark_theme.dart';
import 'package:visionary_walls/themes/light_theme.dart';

void main() {
  runApp(const MainApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),

      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/download': (context) => DownloadScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/view') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (_) => ViewScreen(
                  info: args['info'],
                  infos: args['infos'],
                  index: args['index'],
                ),
          );
        }
        return null;
      },
    );
  }
}
