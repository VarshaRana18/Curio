import 'package:curio/services/chat_web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ResponseSection extends StatefulWidget {
  const ResponseSection({super.key});
  @override
  State<ResponseSection> createState() => _ResponseSectionState();
}

class _ResponseSectionState extends State<ResponseSection> {
  bool isLoading = true;
  List<dynamic> sources = [];
  String response = """
  ## Lists

Unordered

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

  """;

  @override
  void initState() {
    super.initState();
    ChatWebService().contentStream.listen((data) {
      if (isLoading) {
        response = "";
      }
      setState(() {
        response += data['data'] ?? "";
        isLoading = false;
      });
    });

    ChatWebService().searchResultStream.listen((data) {
      setState(() {
        sources = data['data'] ?? [];
      });
    });
  }

  String _formatCitations(String rawText) {
    final citationRegex = RegExp(r'\[(\d+)\]');
    return rawText.replaceAllMapped(citationRegex, (match) {
      final index = match.group(1);
      return '[[^$index]](citation:$index)';
    });
  }

  Future<void> _handleLinkTap(String href) async {
    // if (href == null) return;
    String? targetUrl;

    if (href.startsWith('citation:')) {
      final indStr = href.replaceFirst('citation:', '');
      final index = int.tryParse(indStr);

      if (index != null && index > 0 && index <= sources.length) {
        targetUrl = sources[index - 1]['url'];
      }
    } else {
      targetUrl = href;
    }

    if (targetUrl != null && targetUrl.isNotEmpty) {
      final uri = Uri.parse(targetUrl);
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (e) {
        debugPrint("Could not launch $targetUrl: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedMarkdown = _formatCitations(response);

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

        Skeletonizer(
          enabled: isLoading,
          child: MarkdownBody(
            data: response.isEmpty
                ? "Synthesizing research..."
                : formattedMarkdown,
            onTapLink: (text, href, title) {
              _handleLinkTap(href!);
            },
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
        ),
      ],
    );
  }
}
