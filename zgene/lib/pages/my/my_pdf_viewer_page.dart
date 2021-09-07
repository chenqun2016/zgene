import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:zgene/util/base_widget.dart';

class MyPdfViewerPage extends BaseWidget {
  var model;

  MyPdfViewerPage(dynamic model) {
    this.model = model;
  }

  @override
  BaseWidgetState<BaseWidget> getState() => _MyPdfViewerPageState();
}

class _MyPdfViewerPageState extends BaseWidgetState {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    pageWidgetTitle = "model";
    isListPage = true;
    customRightBtnImg = "assets/images/mine/icon_xiazai.png";
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return SfPdfViewer.network(
        "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf");
  }
}
