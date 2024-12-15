import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

Future<bool> confirmDialog(BuildContext context,
    {required String title,
    required String message,
    String okButtonText = 'OK',
    String cancelButtonText = 'Отмена',
    bool cancelOkDirection = true}) async {
  //Для результата
  bool result = false;
  //Откроем диалоговое окно и дождемся его закрытия
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            title,
            style: AppTheme.appTextStyle('Title'),
          ),
          content: Text(
            message,
            style: AppTheme.appTextStyle('BodyLight'),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelOkDirection == true
                    //Кнопка отмены в начале
                    ? TextButton(
                        onPressed: () {
                          //Зафиксируем ответ
                          result = false;
                          //Закроем окно диалога
                          Navigator.pop(context);
                        },
                        child: Text(
                          cancelButtonText.toUpperCase(),
                          style: AppTheme.buttonTextStyle(
                              color: AppTheme.appColor('CancelButton')),
                        ),
                      )
                    : Container(),

                //Кнопка Ок
                TextButton(
                  onPressed: () {
                    //Зафиксируем ответ
                    result = true;
                    //Закроем окно диалога
                    Navigator.pop(context);
                  },
                  child: Text(
                    okButtonText.toUpperCase(),
                    style: AppTheme.buttonTextStyle(
                        color: AppTheme.appColor('OkButton')),
                  ),
                ),
                cancelOkDirection == false
                    //Кнопка отмены в конце
                    ? TextButton(
                        onPressed: () {
                          //Зафиксируем ответ
                          result = false;
                          //Закроем окно диалога
                          Navigator.pop(context);
                        },
                        child: Text(
                          cancelButtonText.toUpperCase(),
                          style: AppTheme.buttonTextStyle(
                              color: AppTheme.appColor('CancelButton')),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        );
      }); //showDialog

  //Вернем результат выбора
  return result;
}
