import 'package:curio/widgets/prompt_section.dart';
import 'package:curio/services/chat_web_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Required for ImageFilter

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String fullResponse = "";
  @override
  void initState() {
    super.initState();
    ChatWebService().connect();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive positioning
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Top Right Soft Purple Glow
          Positioned(
            top: size.height * 0.1,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(
                  255,
                  244,
                  213,
                  255,
                ).withOpacity(0.6), // Soft Lilac
              ),
            ),
          ),

          // 2. Bottom Left Soft Pink Glow
          Positioned(
            bottom: size.height * 0.10,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFBCFE8).withOpacity(0.5), // Pale Pink
              ),
            ),
          ),

          // 3. Center Indigo Glow
          Positioned(
            top: size.height * 0.4,
            left: size.width * 0.1,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC4B5FD).withOpacity(0.4), // Soft Indigo
              ),
            ),
          ),

          // 4. The Magic Blur Layer
          // This creates the seamless "mesh" effect by blurring the circles below it
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 5. Your Foreground UI Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF8B5CF6),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hey, I'm ",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        "Curio",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),

                  PromptArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
