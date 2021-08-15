// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: BarCodeScanner(),
    );
  }
}

class BarCodeScanner extends StatefulWidget {
  const BarCodeScanner({Key? key}) : super(key: key);

  @override
  _BarCodeScannerState createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  String scanRes = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Tsundoku Barcode Scan')
      ),
      body: Center(
        child: barCodeScanWidget()
      )
    );
  }

  Widget barCodeScanWidget() {
    return Column(
      children: <Widget>[
        TextButton(onPressed: () {initScanner();}, child: const Text("Scan Barcode")),
        Text(scanRes),
      ],
    );
  }

  Future  initScanner() async {
    String _response;
    try {
      _response = await FlutterBarcodeScanner.scanBarcode("#000000", "cancel", false, ScanMode.BARCODE);
    } on PlatformException {
      _response = "Exception";
    } on MissingPluginException {
      _response = "This device is not supported for scan";
    }
    if (!mounted) return;
    String body = await getBookInfo(_response);
    setState(() {scanRes = body;});
  }

  Future<String> getBookInfo(String isbn) async {
    final url = Uri.parse("https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?applicationId=1061425402880145672&isbn=$isbn");
    http.Response response = await http.get(url, headers: {'Accept' : 'application/json'});
    return response.body.toString();
  }
 }


class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved,)
        ]
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(padding: const EdgeInsets.all(16.0),itemBuilder: (context, i) {
      if(i.isOdd) return const Divider();
      final index = i ~/ 2;
      if(index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red: null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved) {
            _saved.remove(pair);
          }else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
              (WordPair pair){
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  )
                );
              }
          );
          final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions')
            ),
            body: ListView(children: divided)
          );
        }
      )
    );
  }
}
