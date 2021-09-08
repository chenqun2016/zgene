import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/my_report_list_page.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';

class MyPdfViewerPage extends BaseWidget {
  MyReportListPage model;

  MyPdfViewerPage(dynamic model) {
    this.model = model;
  }

  @override
  BaseWidgetState<BaseWidget> getState() => _MyPdfViewerPageState();
}

class _MyPdfViewerPageState extends BaseWidgetState<MyPdfViewerPage> {
  PdfViewerController _pdfViewerController;

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    pageWidgetTitle = widget.model.targetName + "的基因检测报告";
    isListPage = true;
    customRightBtnImg = "assets/images/mine/icon_xiazai.png";
    _pdfViewerController = new PdfViewerController();
    _getPDF();
  }

  File file;
  String savePaths;
  _getPDF() async {
    Dio dio = await HttpUtils.createInstance();
    getApplicationSupportDirectory().then((value) {
      savePaths = value.path + '${widget.model.id}.pdf';
      var f = File(savePaths);
      if (f.existsSync()) {
        file = f;
        setState(() {
        });
      } else {
        download1(dio, CommonUtils.splicingUrl(widget.model.url), savePaths);
      }
    });
  }

  @override
  Widget viewPageBody(BuildContext context) {
    print(CommonUtils.splicingUrl(widget.model.url));

    return null == file
        ? Text("")
        : SfPdfViewer.file(
            file,
            controller: _pdfViewerController,
            onDocumentLoaded: (s) {
              print("onDocumentLoaded");
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails e) {
              print("onDocumentLoadFailed==" + e.description + "///" + e.error);
            },
          );
  }

  @override
  Future rightBtnTap(BuildContext context) async {
    var dio = await HttpUtils.createInstance();
    return await download1(dio, CommonUtils.splicingUrl(widget.model.url),
        './report/${widget.model.id}.pdf');
  }

  //Another way to downloading small file
  Future download2(Dio dio, String url, String savePath) async {
    print("savePath==" + savePath);
    try {
      var response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      file = File(savePath);
      var ex = file.existsSync();
      if (!ex) {
        file.createSync();
      }
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }



  Future download1(Dio dio, String url, savePath) async {
    var cancelToken = CancelToken();
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: showDownloadProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      var process = received / total;
      if (1 == process) {
        EasyLoading.dismiss();
        file = File(savePaths);
        setState(() {});
      } else {
        EasyLoading.showProgress(process, status: "下载中...");
      }
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }
}
