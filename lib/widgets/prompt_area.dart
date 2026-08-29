import 'package:flutter/material.dart';

class PromptArea extends StatelessWidget {
  const PromptArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            color: const Color.fromARGB(255, 150, 150, 150),
            onPressed: () {},
          ),
          const Expanded(
            child: TextField(
              cursorColor: Color(0xFF8B5CF6),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Ask anything..",
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF8B5CF6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send_rounded, size: 20),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
