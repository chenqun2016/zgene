import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = void Function(String key);

///用户协议和隐私政策
class PrivacyView extends StatefulWidget {
  final String data;
  final List<String> keys;
  final TextStyle style;
  final TextStyle keyStyle;
  final OnTapCallback onTapCallback;

  const PrivacyView({
    Key key,
     this.data,
     this.keys,
    this.style,
    this.keyStyle,
    this.onTapCallback,
  }) : super(key: key);

  @override
  _PrivacyViewState createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  List<String> _list = [];

  @override
  void initState() {
    _split();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <InlineSpan>[
            ..._list.map((e) {
              if (widget.keys.contains(e)) {
                return TextSpan(
                  text: '$e',
                  style: widget.keyStyle ??
                      TextStyle(color: Theme.of(context).primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.onTapCallback.call(e);
                    },
                );
              } else {
                return TextSpan(text: '$e', style: widget.style);
              }
            }).toList()
          ]),
    );
  }

  void _split() {
    int startIndex = 0;
    Map<String, dynamic> _index;
    int i=0;
    while ((_index = _nextIndex(startIndex)) != null) {
      i = _index['index'];
      String sub = widget.data.substring(startIndex, i);
      if (sub.isNotEmpty) {
        _list.add(sub);
      }
      _list.add(_index['key']);
      startIndex = i + (_index['key'] as String).length;
    }
    _list.add(widget.data.substring(_list.toString().length-8,widget.data.length));
  }

  Map<String, dynamic> _nextIndex(int startIndex) {
    int currentIndex = widget.data.length;
    String key;
    widget.keys.forEach((element) {
      int index = widget.data.indexOf(element, startIndex);
      if (index != -1 && index < currentIndex) {
        currentIndex = index;
        key = element;
      }
    });
    if (key == null) {
      return null;
    }
    return {'key': '$key', 'index': currentIndex};
  }
}