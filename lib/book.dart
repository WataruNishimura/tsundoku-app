import 'dart:convert';

class Book {
  String _title = "";
  String _isbn = "";
  String _author = "";
  String _caption = "";
  DateTime salesDate = DateTime(2020,1,1,0,0,0,0,0);

  Book(this._title, this._isbn, this._author, this._caption);

  Book.fromJson(Map<String, dynamic> book) {
    _title = book["Item"]["title"];
    _isbn = book["Item"]["isbn"];
    _author = book["Item"]["author"];
    _caption = book["Item"]["itemCaption"];
  }
  String get title { return _title; }
  String get isbn { return _isbn; }
  String get author { return _author; }
  String get caption { return _caption; }

}
