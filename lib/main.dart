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
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      home: HomePage(),
    );
  }
}

// Expanded(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.all(16),
//                       child: StreamBuilder(
//                         stream: ChatWebService().contentStream,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                                   ConnectionState.waiting &&
//                               !snapshot.hasData) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }

//                           if (snapshot.hasError) {
//                             return Text("Error: ${snapshot.error}");
//                           }

//                           if (snapshot.hasData) {
//                             // Extract data safely based on server JSON payload
//                             final chunk =
//                                 snapshot.data?["data"] ??
//                                 snapshot.data?["content"] ??
//                                 "";
//                             fullResponse += chunk;
//                           }

//                           return Text(
//                             fullResponse,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black87,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
