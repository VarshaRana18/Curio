import 'package:curio/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(Curio());
}

class Curio extends StatelessWidget {
  const Curio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Curio",
      theme: ThemeData(
        textTheme: GoogleFonts.overlockTextTheme(Theme.of(context).textTheme),
      ),
      home: HomePage(),
    );
  }
}
