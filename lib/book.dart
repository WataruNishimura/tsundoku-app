import 'dart:convert';

class Book {
  String title = "";
  String isbn = "";

  Book(this.title, this.isbn);

  Book.fromJson(Map<String, dynamic> book) {
    title = book["Item"]["title"];
    isbn = book["Item"]["isbn"];
  }
  getTitle() {
    return title;
  }

  getIsbn() {
    return isbn;
  }
}
