// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kitaabs_library/screens/pdf_view_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/book_model.dart';

Future<void> uploadFile(File file, String title) async {
  final storageRef = FirebaseStorage.instance
      .ref()
      .child('books/${file.uri.pathSegments.last}');
  await storageRef.putFile(file);
  final fileUrl = await storageRef.getDownloadURL();

  // Store the file URL in Firestore
  await FirebaseFirestore.instance.collection('books').add({
    'title': title,
    'url': fileUrl,
  });
}

Future<List<Book>> fetchBooks() async {
  final booksSnapshot =
      await FirebaseFirestore.instance.collection('books').get();
  return booksSnapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
}

Future<void> downloadFile(String url, String filename) async {
  final response = await http.get(Uri.parse(url));
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename.pdf');
  await file.writeAsBytes(response.bodyBytes);
}

Future<void> readOffline(BuildContext context, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename.pdf');

  if (await file.exists()) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PdfViewerPage(book: Book(title: 'Offline Book', url: file.path)),
      ),
    );
  }
}
