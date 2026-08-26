import 'package:flutter/material.dart';

void main() {
  runApp(Curio());
}

class Curio extends StatelessWidget {
  const Curio({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text("Initial Curio Screen"))),
    );
  }
}
