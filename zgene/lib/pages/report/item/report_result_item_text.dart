import 'package:base/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';

class ReportResultItemText extends StatefulWidget {
  String text;
  ReportResultItemText({Key key, this.text}) : super(key: key);

  @override
  _ReportResultItemTextState createState() => _ReportResultItemTextState();
}

class _ReportResultItemTextState extends State<ReportResultItemText> {
  bool expand = false;
  int maxLines = 6;
  final style = TextStyle(
      fontSize: 15,
      overflow: TextOverflow.ellipsis,
      color: ColorConstant.text_112950,
      fontWeight: FontWeight.w500);

  final gradient1 = LinearGradient(
      colors: [
        Color(0xFFEDF3F6),
        Color(0xFFffffff),
        Color(0xFFffffff),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 0.9, 1.0]);
  final gradient2 = LinearGradient(colors: [
    Color(0xFFEDF3F6),
    Color(0xFFEBEFF1).withAlpha(25),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  String text;
  @override
  void initState() {
    text = widget.text;
    super.initState();
  }

  bool _isHtml() {
    return text.contains('</');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: _isHtml()
              ? EdgeInsets.fromLTRB(5, 0, 5, expand ? 0 : 10)
              : EdgeInsets.all(15),
          margin:
              EdgeInsets.only(left: 15, right: 15, bottom: expand ? 15 : 25),
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: expand ? gradient2 : gradient1,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: LayoutBuilder(builder: (context, size) {
            final painter = TextPainter(
              text: TextSpan(text: text, style: style),
              maxLines: maxLines,
              textDirection: TextDirection.ltr,
            );
            painter.layout(maxWidth: size.maxWidth);
            if (!painter.didExceedMaxLines) {
              expand = true;
              return Html(
                data: text,
                shrinkWrap: true,
              );
              // : Text(text, maxLines: maxLines, style: style);
            }
            return expand
                ? Html(
                    data: text,
                    shrinkWrap: true,
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 117,
                        child: Html(
                          data: text,
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  );
          }),
        ),
        if (!expand)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 65,
                margin: EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white.withAlpha(0),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                width: double.infinity,
              )),
        if (!expand)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => setState(() {
                  expand = !expand;
                }),
                child: Image.asset(
                  "assets/images/report/report_jiantou.png",
                  height: 40,
                  width: 40,
                ),
              )),
      ],
    );
  }
}
