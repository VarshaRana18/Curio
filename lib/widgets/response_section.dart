import 'package:curio/services/chat_web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ResponseSection extends StatefulWidget {
  @override
  State<ResponseSection> createState() => _ResponseSectionState();
}

class _ResponseSectionState extends State<ResponseSection> {
  String response = "";

  @override
  void initState() {
    super.initState();
    ChatWebService().contentStream.listen((data) {
      setState(() {
        response += data['data'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome, size: 20, color: Color(0xFF8B5CF6)),
            SizedBox(width: 8),
            Text(
              "Answer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF7C3AED),
              ),
            ),
          ],
        ),

        const Divider(height: 24, color: Color(0xFFF3E8FF)),

        MarkdownBody(
          data: response.isEmpty ? "Thinking..." : response,
          shrinkWrap: true,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
            h1: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
            h2: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
            code: TextStyle(
              backgroundColor: const Color(0xFFF3E8FF).withOpacity(0.5),
              color: const Color(0xFF6D28D9),
              fontSize: 14,
            ),
            codeblockDecoration: BoxDecoration(
              color: const Color(0xFFF8F6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9D5FF)),
            ),
          ),
        ),
      ],
    );
  }
}
