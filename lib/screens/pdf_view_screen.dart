import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../model/book_model.dart';

class PdfViewerPage extends StatelessWidget {
  final Book book;

  const PdfViewerPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: PDFView(
        filePath: book.url,
      ),
    );
  }
}
