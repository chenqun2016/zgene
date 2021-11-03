import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zgene/constant/color_constant.dart';

class ReportResultItemText extends StatefulWidget {
  String text;
  ReportResultItemText({Key key, this.text}) : super(key: key);

  @override
  _ReportResultItemTextState createState() => _ReportResultItemTextState();
}

class _ReportResultItemTextState extends State<ReportResultItemText> {
  bool expand = false;
  int maxLines = 5;
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
    return Container(
      width: double.infinity,
      padding: _isHtml() ? EdgeInsets.fromLTRB(5, 0, 5, 0) : EdgeInsets.all(15),
      margin: EdgeInsets.only(left: 0, right: 0),
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
        if (!painter.didExceedMaxLines)
          return _isHtml()
              ? Html(
                  data: text,
                  shrinkWrap: true,
                )
              : Text(text, maxLines: maxLines, style: style);
        return Stack(
          children: <Widget>[
            _isHtml()
                ? expand
                    ? SizedBox(
                        child: Html(
                          data: text,
                          shrinkWrap: true,
                        ),
                      )
                    : SizedBox(
                        height: 104,
                        child: Html(
                          data: text,
                          shrinkWrap: true,
                        ),
                      )
                : Text(text, maxLines: expand ? 1000 : maxLines, style: style),
            if (!expand)
              Positioned(
                  right: _isHtml() ? 5 : 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      expand = !expand;
                    }),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(" ...  "),
                          Image.asset(
                            "assets/images/report/icon_jiantou_down.png",
                            height: 18,
                            width: 18,
                          )
                        ],
                      ),
                    ),
                  )),
          ],
        );
      }),
    );
  }
}
