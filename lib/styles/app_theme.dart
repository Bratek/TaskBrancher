import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/styles/color_styles.dart';
import 'package:task_brancher/styles/text_styles.dart';

class AppTheme {
//Цвет по ключу
  static Color appColor(String key) {
    if (appColors[key] == null) {
      return Colors.red;
    } else {
      return appColors[key]!;
    }
  }

//Цвет по статусу
  static Color statusColor(Status status, {bool isCard = false}) {
    switch (status) {
      case Status.none:
        return isCard ? appColors['StatusNoneCard']! : appColors['StatusNone']!;
      case Status.inprogress:
        return isCard
            ? appColors['StatusInprogressCard']!
            : appColors['StatusInprogress']!;
      case Status.verify:
        return isCard
            ? appColors['StatusVerifyCard']!
            : appColors['StatusVerify']!;
      case Status.completed:
        return isCard
            ? appColors['StatusCompletedCard']!
            : appColors['StatusCompleted']!;
      case Status.calceled:
        return isCard
            ? appColors['StatusCalceledCard']!
            : appColors['StatusCalceled']!;
    }
  }

//Стиль текста по ключу
  static TextStyle appTextStyle(String key) {
    if (appTextStyles[key] == null) {
      return const TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.red);
    } else {
      return appTextStyles[key]!;
    }
  }

//Стиль текста по статусу
  static TextStyle statusTextStyle(Status status) {
    return TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: statusColor(status));
  }
}
