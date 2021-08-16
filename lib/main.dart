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


