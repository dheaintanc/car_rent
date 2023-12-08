import 'package:car_rental/model/carRentsDatabase.dart';
import 'package:car_rental/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

String CarName = 'carRentalBox';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<CarRentsData>(CarRentsDataAdapter());
  await Hive.openBox<CarRentsData>(CarName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sukalapak: Car rent app',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(),
    );
  }
}
