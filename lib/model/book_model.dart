import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String url;

  Book({required this.title, required this.url});

  factory Book.fromDocument(DocumentSnapshot doc) {
    return Book(
      title: doc['title'],
      url: doc['url'],
    );
  }
}
