import 'package:flutter/widgets.dart';
import 'package:task_brancher/services/app_library.dart';

Project? currentProject;
Settings appSettings = DataBase.getSettings();

void navigateToScreen(BuildContext context,
    {required String routeName, Base? arguments}) {
  arguments ??= currentProject;

  Navigator.of(context).popUntil((route) {
    if (route.isFirst) {
      if (route.settings.name != routeName) {
        Navigator.of(context).pushNamed(routeName, arguments: arguments);
      }
      return true;
    }
    return route.settings.name == routeName; // Удаляем все маршруты, не соответствующие заданному имени
  });
}
