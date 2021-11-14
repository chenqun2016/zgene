import 'package:base/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:zgene/widget/star_shape_border.dart';

///患病倍数
class ReportResultItem1 extends StatefulWidget {
  var minRisk;
  var maxRisk;
  var risk;
  ReportResultItem1({Key key, this.minRisk, this.maxRisk, this.risk})
      : super(key: key);

  @override
  _ReportResultItem1State createState() => _ReportResultItem1State();
}

class _ReportResultItem1State extends State<ReportResultItem1> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 64;
    var minRisk = widget.minRisk;
    var maxRisk = widget.maxRisk;
    var risk = widget.risk;
    double left = (risk - minRisk) / (maxRisk - minRisk) * width - 20;
    if (left < 0) {
      left = 0;
    }
    if (left > width - 40) {
      left = width - 40;
    }
    print("left==" + left.toString() + "/width==" + width.toString());
    var space = (maxRisk - minRisk) / 3;
    var color;
    if (risk < space + minRisk) {
      color = ColorConstant.bg_24D780;
    } else if (risk < space * 2 + minRisk) {
      color = ColorConstant.bg_017AF6;
    } else {
      color = ColorConstant.bg_FD7A7A;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Container(
            height: 36,
            child: Stack(
              children: [
                Positioned(
                  top: 24,
                  child: Container(
                    width: width * 2 / 3,
                    height: 10,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      color: ColorConstant.bg_24D780,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 24,
                    right: 0,
                    child: Container(
                      width: width * 2 / 3,
                      height: 10,
                      padding: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        color: ColorConstant.bg_017AF6,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    )),
                Positioned(
                    top: 24,
                    right: 0,
                    child: LayoutBuilder(
                      builder: (_, zone) {
                        return Container(
                          width: width * 1 / 3,
                          height: 10,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: ColorConstant.bg_FD7A7A,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        );
                      },
                    )),
                Positioned(
                    left: left,
                    top: 0,
                    child: Column(
                      children: [
                        ClipPath(
                          clipper: ShapeBorderClipper(shape: StarShapeBorder()),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(6, 3, 6, 5),
                            constraints: BoxConstraints(
                              minWidth: 30,
                            ),
                            color: color,
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //         "assets/images/report/icon_qipao.png"),
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            child: Text(
                              widget.risk.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                        Container(
                            height: 14,
                            width: 14,
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color,
                                width: 4,
                              ),
                              color: ColorConstant.WhiteColor,
                            ))
                      ],
                    ))
              ],
            ),
          ),
          Divider(
            height: 10,
            color: Colors.transparent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.minRisk.toString(),
                style: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Text(
                ((widget.minRisk + widget.maxRisk) / 2).toStringAsFixed(3),
                style: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Text(
                widget.maxRisk.toString(),
                style: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              )
            ],
          )
        ],
      ),
    );
  }
}
