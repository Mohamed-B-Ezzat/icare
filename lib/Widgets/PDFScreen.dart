import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

import 'main_menu.dart';

class PDFScreen extends StatefulWidget {
  // final File PDFFile;
  final String pdfPath;
  final String FileTitle;

  PDFScreen({Key? key,required this.pdfPath,required this.FileTitle}) : super(key: key);

  @override
  State<PDFScreen> createState() => _PDFScreenState(this.pdfPath,this.FileTitle);
}

class _PDFScreenState extends State<PDFScreen> {
  bool _isLoading = true;

  // File PDFFile;
  String pdfPath;
  String FileTitle;

  _PDFScreenState(this.pdfPath,this.FileTitle);


  void _loadFile() async {
    // Load the pdf file from the internet



    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MainMenu(),
        appBar: AppBar(
          title: Text(FileTitle,
            style: const TextStyle(
              color: Colors.white,),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share Pdf',
              onPressed: () async {
                List<String> Paths = [pdfPath];
                Share.shareFiles(Paths, subject: FileTitle);
              },
            ), //IconButton
          ], //<Widget>[]          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color.fromRGBO(47, 150, 185, 1), Color.fromRGBO(84, 199, 212, 1),Color.fromRGBO(47, 150, 185, 1)])
            ),
          ),
          elevation: 0,

        ),
        body: Center(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SfPdfViewer.file(
                File(pdfPath))
        )
    );
  }

  // Future<void> _sharePdf() async {
  //   try {
  //     final ByteData bytes = await rootBundle.load('assets/addresses.csv');
  //     await Share.file(
  //         'addresses', 'addresses.csv', bytes.buffer.asUint8List(), 'text/csv');
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }

}