import 'package:flutter/services.dart';

class InputFormat extends TextInputFormatter {
  InputFormat({this.decimalRange = 2})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;
  int position;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    String positionStr = (text.substring(0, newValue.selection.baseOffset))
        .replaceAll(RegExp(r"\s+\b|\b\s"), ""); //获取光标左边的文本
    //计算格式化后的光标位置
    int length = positionStr.length;
    if (length <= 3) {
      position = length;
    } else if (length <= 7) {
      position = length + 1;
    } else if (length <= 11) {
      position = length + 2;
    } else {
      position = 13;
    }
    //这里格式化整个输入文本
    text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    String string = "";
    for (int i = 0; i < text.length; i++) {
      if (i > 10) {
        break;
      }
      if (i == 3 || i == 7) {
        if (text[i] != " ") {
          string = string + " ";
        }
      }
      string = string + text[i];
    }
    text = string;
    return TextEditingValue(
      text: text,
      selection: TextSelection.fromPosition(
          TextPosition(offset: position, affinity: TextAffinity.upstream)),
    );
  }
}
