import 'package:carwash/screen/Landing.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IndexViewModel>(create: (context) {
          return IndexViewModel();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Wash',
        theme: ThemeData(
          appBarTheme: AppBarTheme(),
          inputDecorationTheme: InputDecorationTheme(
            suffixIconColor: Colors.black54,
            prefixIconColor: Colors.black54,
            iconColor: Colors.grey,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
            ),
            labelStyle: TextStyle(color: Colors.black54),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),

        ),
        initialRoute: 'landing',
        routes: {
          'landing': (context) => LandingPage(),
        },
      ),
    );
  }
}


