import 'package:flutter/material.dart';

// class TextStylePage{

//   static TextStyle getStyle(Locale _locale,String textColor,String text,String price,String priceBold){
//     TextStyle fontStyle=TextStyle(
//       fontFamily: _locale==Locale('mm')?"myanmar3":"Roboto Slab Regular",
//       color:textColor=="white"?Colors.white:
//         (textColor=="black"?Colors.black:textColor=="grey"?Colors.grey:
//         (textColor=="red")?Colors.red:
//         (textColor=="blue"?Colors.blue:Color(0xff4AB055))
//         ),
//       fontSize: text=="header"?ScreenUtil().setSp(60,allowFontScalingSelf: true):
//         (text=="bottomtab"?ScreenUtil().setSp(25,allowFontScalingSelf: true):
//         (text=="price"?ScreenUtil().setSp(80,allowFontScalingSelf: true):
//         ScreenUtil().setSp(35,allowFontScalingSelf: true))),
//       fontWeight: text=="header"||priceBold=="bold"?FontWeight.bold:FontWeight.normal,
//       decoration: price=="oldPrice"?TextDecoration.lineThrough:TextDecoration.none,
//     );
//     return fontStyle;
//   }
// }

class PageTheme{
  static ThemeData getThemeData(){
    return ThemeData(
      primaryColor:Colors.white,//Colors.orange[400],
     // fontFamily: UserInfo.currentLocale==Locale('mm')?"myanmar3":"Roboto Slab Regular",
     fontFamily: "pyidaungsu",
      brightness: Brightness.light,
      primaryIconTheme:IconThemeData(color:  Colors.orange[500]),
      iconTheme: new IconThemeData(
        color:Color.fromRGBO(78, 179, 177, 1.0),
       // opacity: 0.7

      ),

    );
  }
}