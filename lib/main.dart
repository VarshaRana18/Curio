import 'package:curio/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Curio());
}

class Curio extends StatelessWidget {
  const Curio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
