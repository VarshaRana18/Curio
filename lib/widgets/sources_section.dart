import 'package:curio/services/chat_web_service.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceSection extends StatefulWidget {
  @override
  State<SourceSection> createState() => _SourceSectionState();
}

class _SourceSectionState extends State<SourceSection> {
  bool isLoading = true;
  List sources = [
    {
      'title': 'Mr Elon Musk FRS',
      'url': 'https://royalsociety.org/people/elon-musk-13829/',
    },
    {'title': 'Elon Musk', 'url': 'https://en.wikipedia.org/wiki/Elon_Musk'},
    {
      'title': 'Elon Musk : The Owner',
      'url': 'https://www.tesla.com/elon-musk',
    },
  ];

  @override
  void initState() {
    super.initState();
    ChatWebService().searchResultStream.listen((data) {
      setState(() {
        sources = data['data'];
        isLoading = false;
      });
    });
  }

  Future<void> _openSourceUrl(String? url) async {
    if (isLoading || url == null || url.isEmpty) return;

    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint("Could not launch $url: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Skeletonizer(
        enabled: isLoading,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sources.length,
          itemBuilder: (context, index) {
            final item = sources[index];

            return Container(
              width: 150,
              margin: const EdgeInsets.only(right: 10),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openSourceUrl(item['url'] ?? ''),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF3E8FF)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "[${index + 1}] ${item['title'] ?? 'Source'}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF7C3AED),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item['url'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black45,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
