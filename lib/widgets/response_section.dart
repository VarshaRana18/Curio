import 'package:curio/services/chat_web_service.dart';
import 'package:flutter/material.dart';

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

        Text(
          response,
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
