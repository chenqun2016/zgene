import 'package:zgene/constant/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


////修改昵称页面
class nikeNameChange extends StatefulWidget {
  String nikeName = "";
  nikeNameChange({Key key, this.nikeName}) : super(key: key);

  @override
  _nikeNameChangeState createState() => _nikeNameChangeState();
}

class _nikeNameChangeState extends State<nikeNameChange> {
  String _nakeName = "";
  String _nakeNameError = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.WhiteColor,
        brightness: Brightness.light,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/mine/icon_mine_backArrow.png"),
            size: 16,
            color: ColorConstant.MainBlack,
          ),
          onPressed: () {
            Navigator.pop(context, _nakeName);
          },
        ),
        elevation: 0,
        title: Text(
          "修改昵称",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: ColorConstant.MainBlack),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (_nakeName == "") {
                  _nakeNameError = "请填写修改后的昵称";
                } else {
                  _nakeNameError = null;
                  Navigator.pop(context, _nakeName);
                }
                setState(() {});
              },
              child: Text(
                "保存",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.TextMainGray,
                ),
              ))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: TextField(
          // keyboardType: TextInputType.number,
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
          maxLength: maxLength,
          onChanged: (value) {
            _changeMaxLimit(value);
            _nakeName = value;
            if (value == "") {
              _nakeNameError = null;
              setState(() {});
            }
          },
          autofocus: true,
          decoration: InputDecoration(
            labelText: widget.nikeName != null ? widget.nikeName : "",
            // hintStyle: TextStyle(color: ColorConstant.BgColor),
            border: OutlineInputBorder(),
            errorText: _nakeNameError,
          ),
        ),
      ),
    );
  }

  int maxLength;
  void _changeMaxLimit(String value) {
    maxLength = 16;
    for (int i = 0; i < value.length; i++) {
      if (value.codeUnitAt(i) > 122) {
        maxLength -= 1;
      }
    }
    setState(() {});
  }
}
