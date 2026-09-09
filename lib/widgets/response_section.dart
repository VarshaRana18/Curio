import 'package:curio/services/chat_web_service.dart';
import 'package:curio/services/pdf_export_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ResponseSection extends StatefulWidget {
  final String query;
  ResponseSection({super.key, this.query = ""});
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
      final innerContent = match.group(1) ?? '';
      final numberRegex = RegExp(r'\d+');
      final matches = numberRegex.allMatches(innerContent);

      if (matches.isEmpty) {
        return match.group(0) ?? ''; // Fallback if no numbers found
      }

      return matches
          .map((m) {
            final index = m.group(0);
            return '[[^$index]](citation:$index)';
          })
          .join(' ');
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

  void _copyToClipboard() {
    if (response.isEmpty) return;
    Clipboard.setData(ClipboardData(text: response));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text("Markdown response copied to clipboard!"),
          ],
        ),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _exportPdf() {
    if (response.isEmpty) return;
    PdfExportService.exportResearchReport(
      query: widget.query,
      responseText: response,
      sources: sources,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedMarkdown = _formatCitations(response);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: Color(0xFF8B5CF6),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Answer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: Colors.black54,
                  ),
                  tooltip: "Copy Markdown",
                  onPressed: _copyToClipboard,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 18,
                    color: Color(0xFF7C3AED),
                  ),
                  tooltip: "Export PDF Report",
                  onPressed: _exportPdf,
                ),
              ],
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
