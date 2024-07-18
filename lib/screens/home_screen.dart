// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:kitaabs_library/screens/pdf_view_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/book_model.dart';
import '../provider/book_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  bool isLoading = true;

  Future<void> requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    fetchBooks().then((bookList) {
      setState(() {
        books = bookList;
        isLoading = false;
      });
    });
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Online Library')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text('No books available'))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book.title),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerPage(book: book),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => downloadFile(book.url, book.title),
                      ),
                    );
                  },
                ),
    );
  }
}
