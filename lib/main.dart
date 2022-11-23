import 'package:flutter/material.dart';
import 'package:flutter_simple_cms/api/services.dart';
import 'package:flutter_simple_cms/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiServices().initialize().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple CMS',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
