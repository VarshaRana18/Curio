import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  static Future<void> exportResearchReport({
    required String query,
    required String responseText,
    required List<dynamic> sources,
  }) async {
    final pdf = pw.Document();
    final cleanPlainText = stripMarkdown(responseText);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Curio Research Summary",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.indigo900,
                  ),
                ),
                pw.Text(
                  DateTime.now().toString().split(' ')[0],
                  style: const pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Topic / Question:",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  query.isEmpty ? "AI Search Inquiry" : query,
                  style: const pw.TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 16),
          if (sources.isNotEmpty) ...[
            pw.Text(
              "Sources & References",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.indigo800,
              ),
            ),
            pw.SizedBox(height: 6),
            ...sources.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final item = entry.value;
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text(
                  "[$idx] ${item['title'] ?? 'Web Source'} — ${item['url'] ?? ''}",
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.blueGrey800,
                  ),
                ),
              );
            }),
            pw.Divider(thickness: 0.5, color: PdfColors.grey400),
            pw.SizedBox(height: 10),
          ],

          pw.Text(
            "Synthesized Answer",
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.indigo800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Paragraph(
            text: cleanPlainText,
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 2),
          ),
        ],
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "Curio_Research_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
  }
}

String stripMarkdown(String markdown) {
  String text = markdown;

  // 1. Remove code blocks (```code```) and inline code (`code`)
  text = text.replaceAll(RegExp(r'```[\s\S]*?```'), '');
  text = text.replaceAllMapped(RegExp(r'`([^`]+)`'), (m) => m[1] ?? '');

  // 2. Remove display math blocks ($$...$$)
  text = text.replaceAll(RegExp(r'\$\$[\s\S]*?\$\$'), '');

  // 3. Remove inline LaTeX/math tokens ($int, $theta)
  text = text.replaceAll(RegExp(r'\$(?!\d)[\s\S]*?\$'), '');
  text = text.replaceAll(RegExp(r'\$[a-zA-Z_]\w*'), '');

  // 4. Remove markdown headers (# Title -> Title)
  text = text.replaceAll(RegExp(r'^\s*#{1,6}\s+', multiLine: true), '');

  // 5. Remove bold & italic syntax cleanly without printing "$2"
  text = text.replaceAllMapped(RegExp(r'\*\*\*(.*?)\*\*\*'), (m) => m[1] ?? '');
  text = text.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (m) => m[1] ?? '');
  text = text.replaceAllMapped(RegExp(r'\*(.*?)\*'), (m) => m[1] ?? '');
  text = text.replaceAllMapped(RegExp(r'___(.*?)___'), (m) => m[1] ?? '');
  text = text.replaceAllMapped(RegExp(r'__(.*?)__'), (m) => m[1] ?? '');
  text = text.replaceAllMapped(RegExp(r'_(.*?)_'), (m) => m[1] ?? '');

  // 6. Clean Markdown links: [Title](url) -> Title
  text = text.replaceAllMapped(
    RegExp(r'\[([^\]]+)\]\([^\)]+\)'),
    (m) => m[1] ?? '',
  );

  // 7. Remove blockquotes and horizontal dividers
  text = text.replaceAll(RegExp(r'^\s*>\s+', multiLine: true), '');
  text = text.replaceAll(RegExp(r'^\s*[-*_]{3,}\s*$', multiLine: true), '');

  // 8. Use standard ASCII hyphen instead of '•' to prevent font rendering boxes
  text = text.replaceAll(RegExp(r'^\s*[\*\-\+]\s+', multiLine: true), '- ');

  // 9. Collapse multiple blank lines
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  return text.trim();
}
