import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tsundoku/book.dart';

void main() async{
  String json;
  json = await loadJson();
  Map<String, dynamic> getData = jsonDecode(json);
  var books = getData['Items'];
  var book = new Book.fromJson(books[0]);
  print(books[0]);

  print("Title: ${book.getTitle()}\nISBN: ${book.getIsbn()}");
}



Future loadJson() async{
  final file = File("bookSample.json");
  final json = await file.readAsString();
  return json;
}
