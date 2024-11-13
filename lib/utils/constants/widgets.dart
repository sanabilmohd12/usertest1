import 'package:flutter/cupertino.dart';
import 'package:testcase1/utils/constants/colors.dart';

Widget lefttitle(String textto,) {
  return Text(textto,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textblack,
      ),
    textAlign: TextAlign.left,
  );
}
//
