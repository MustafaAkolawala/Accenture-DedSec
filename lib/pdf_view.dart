import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDF extends StatefulWidget{
  const PDF({super.key,required this.pdf_url});
final pdf_url;
  @override
  State<StatefulWidget> createState() {
    return _PDFState();
  }

}
class _PDFState extends State<PDF>{
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return Center(child:SfPdfViewer.network(
      widget.pdf_url,
      key: _pdfViewerKey,
    ),);
  }

}