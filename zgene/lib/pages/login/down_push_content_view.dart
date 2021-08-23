import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef GestureTapCallback = void Function();

////下拉框封装
class ContentView extends StatelessWidget {
  // 标题
  final String title;

  //是否必填的标志
  final String mustType;

  //输入框 显示的灰色提示文字
  final String hintText;

  final TextEditingController controller;

  //下拉框数组
  final List contentList;

  // 输入框是否只读 默认 false
  final bool readOnly;

  //文字显示的位置
  final TextAlign textAlign;

  //输入框键盘样式
  final TextInputType keyboardType;

  //输入框右边👉显示的widget
  final Widget suffixIcon;

  //判断 类型 是 输入 还是 下拉选择
  final bool style;

  // 下拉框点击事件
  final ValueChanged<String> onChanged;

  // 输入框输入的类型限制，只能输入数字、汉字等
  final List<TextInputFormatter> inputFormatters;

  // 输入框不可输入时的点击事件
  final GestureTapCallback onTap;
  //光标焦点
  final FocusNode focusNode;

  //输入框左边title的宽度
  final num titleWidth;

  ContentView({
    this.title = '',
    this.mustType = '',
    this.hintText = '',
    this.controller,
    this.contentList,
    this.readOnly = false,
    this.textAlign,
    this.keyboardType,
    this.suffixIcon,
    this.style = false,
    this.onChanged,
    this.inputFormatters,
    this.onTap,
    this.focusNode,
    this.titleWidth,
  });

  factory ContentView.textfield({
    String title = '',
    String mustType = '',
    String hintText = '',
    @required TextEditingController controller,
    bool readOnly = false,
    TextAlign textAlign = TextAlign.start,
    TextInputType keyboardType,
    Widget suffixIcon,
    ValueChanged<String> onChanged,
    List<TextInputFormatter> inputFormatters,
    GestureTapCallback onTap,
    FocusNode focusNode,
    num titleWidth,
  }) {
    return ContentView(
      controller: controller,
      title: title,
      mustType: mustType,
      hintText: hintText,
      readOnly: readOnly,
      textAlign: textAlign,
      keyboardType: keyboardType,
      suffixIcon: suffixIcon,
      style: false,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      onTap: onTap,
      focusNode: focusNode,
      titleWidth: titleWidth,
    );
  }

  factory ContentView.dropdownView({
    String title = '',
    String mustType = '',
    String hintText = '',
    @required TextEditingController controller,
    @required List contentList,
    TextAlign textAlign = TextAlign.start,
    ValueChanged<String> onChanged,
    num titleWidth,
  }) {
    return ContentView(
      controller: controller,
      title: title,
      mustType: mustType,
      hintText: hintText,
      contentList: contentList,
      textAlign: textAlign,
      style: true,
      onChanged: onChanged,
      titleWidth: titleWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Container(
            padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
            child: DropdownButtonFormField(
                isExpanded: true,
                icon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Image(
                    image: AssetImage(
                        "assets/images/mine/icon_mine_downArrow.png"),
                    width: 17,
                    height: 8,
                  ),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
                value: controller.text == '' ? null : controller.text,
                items: contentList
                    .map((title) => DropdownMenuItem(
                  child: Container(
                    child: Text(
                      title,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  value: title,
                ))
                    .toList(),
                onChanged: (title) {
                  controller.text = title;
                  this.onChanged(title);
                }),
            // width: MediaQuery.of(context).size.width - 200,
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
