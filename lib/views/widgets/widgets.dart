import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';

Widget customEditTextStyle(var hintText,
    {int? maxLength,
      enabled = true,
      isPassword = false,
      TextEditingController? controller,
      isTextAre = false,
      GestureTapCallback? onTap,
      TextInputType? keyboardType}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: boxDecoration(radius: 40, showShadow: true, bgColor: whitee),
      child: TextFormField(
        maxLength: maxLength ?? null,
        enabled: enabled,
        textAlign: TextAlign.left,
        controller: controller,
        style: const TextStyle(fontSize: 14, fontFamily: fontRegular,),
        maxLines: isTextAre ? 10 : 1,
        keyboardType: isTextAre ? TextInputType.multiline : keyboardType,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "field_is_required";
          }
          return null;
        },
        decoration: InputDecoration(
          enabled: false,
          contentPadding: EdgeInsets.fromLTRB(18, 14, 18, 14),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: whitee,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
        ),
      ),
    ),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
      Color color = Colors.transparent,
      Color? bgColor,
      var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: shadowColorGlobal)
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

AppBar appBar(BuildContext context, String title,
    {List<Widget>? actions,
      bool showBack = true,
      Color? color,
      Color? iconColor,
      Widget? leadingWidget,
      Color? textColor}) {
  return AppBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    automaticallyImplyLeading: false,
    backgroundColor: mainColor /*learner_white*/,
    leading: showBack
        ? IconButton(
      onPressed: () {
        finish(context);
      },
      icon: Icon(Icons.arrow_back, color: Colors.white /*textColorSecondary*/),
    )
        : (leadingWidget != null)
        ? leadingWidget : null,
    title: text(title , textColor: Colors.white , isBold: true , fontSize: 20.0),
    centerTitle: true,
    // appBarTitleWidget(context, title, textColor: Colors.white /*textColorSecondary*/, color: color ),
    actions: actions,
  );
}


Widget text(
    String? text, {
      var fontSize = textSizeLargeMedium,
      Color? textColor,
      var fontFamily,
      var isCentered = false,
      var maxLine = 3,
      var latterSpacing = 0.5,
      bool textAllCaps = false,
      var isLongText = false,
      bool lineThrough = false,
      bool isBold = false,
      double? wordSpacing ,
    }) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    // maxLines: isLongText ? null : maxLine,
    maxLines: maxLine,
    softWrap: true,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      wordSpacing: wordSpacing ?? 0,
      fontFamily: fontFamily ?? null,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: fontSize,
      color: textColor ?? textColorPrimary,
      height: 1.5,
      //letterSpacing: latterSpacing,
      decoration:
      lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

Widget containerButton(
    {required String label,
      required double btnWidth,
      required Function onTap,}) {
  return Container(
    width: btnWidth,
    alignment: Alignment.center,
    padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
    decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: defaultBoxShadow()),
    child: Text(label, style: boldTextStyle(color: white, size: 18)),
  ).onTap(() {
    onTap();
  });
}

customSnackBar(BuildContext context, {String msg = ""}) {
  showTopSnackBar(
    context,
    CustomSnackBar.info(
      backgroundColor: Colors.blueGrey,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
      icon: const SizedBox.shrink(),
      message: msg,
    ),
  );

}