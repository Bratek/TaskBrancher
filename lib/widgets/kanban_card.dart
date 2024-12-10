import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class KanbanCard extends StatelessWidget {
  final Task task;
  final VoidCallback callbackFunction;

  const KanbanCard(
      {super.key, required this.task, required this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(10),
      //height: 210,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppTheme.statusColor(task.status, isCard: true),
          border: Border.all(color: AppTheme.appColor('Srtoke'), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Номер задачи
          Container(
            height: 22,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(task.number, style: AppTheme.appTextStyle('Title')),
          ),

          //Разделитель
          Divider(
              thickness: 1,
              color: AppTheme.statusColor(task.status),
              indent: 5,
              endIndent: 5),
          Container(
            //height: 100,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Заголовок
                Text(task.title, style: AppTheme.appTextStyle('Title')),
                //Отступ
                const SizedBox(height: 5),
                //Описание
                Text(task.description,
                    softWrap: true,
                    //maxLines: 3,
                    style: AppTheme.appTextStyle('Description')),
                //Отступ
                const SizedBox(height: 5),

                //Кнопка изменения статуса
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        child: SizedBox(
                      width: 10,
                    )),
                    // DropdownButton<Status>(
                    //   borderRadius: BorderRadius.circular(10),
                    //   value: task.status,
                    //   items: global.appSettings.kanbanColumnList
                    //       .map((Status status) {
                    //     return DropdownMenuItem<Status>(
                    //       value: status,
                    //       child: Text(
                    //         status.title,
                    //         style: AppTheme.buttonTextStyle(
                    //             color: AppTheme.statusColor(status)),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (selStatus) {
                    //     task.status = selStatus!;
                    //     HiveService.updateObject(task);
                    //     callbackFunction();
                    //   },
                    // ),
                    PopupMenuButton(
                      initialValue: task.status,
                      elevation: 8,
                      position: PopupMenuPosition.under,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(children: [
                        Icon(Icons.arrow_drop_down,
                            color: AppTheme.statusColor(task.status)),
                        Text(
                          task.status.title,
                          style: AppTheme.appTextStyle('BodyText').copyWith(
                            color: AppTheme.statusColor(task.status),
                          ),
                        ),
                      ]),
                      itemBuilder: (context) =>
                          global.appSettings.kanbanColumnList
                              .map(
                                (status) => PopupMenuItem(
                                  value: status,
                                  child: Text(
                                    status.title,
                                    style: AppTheme.appTextStyle('BodyText')
                                        .copyWith(
                                      color: AppTheme.statusColor(status),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onSelected: (value) {
                        task.status = value;
                        HiveService.updateObject(task);
                        callbackFunction();
                      },
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      width: 1,
                      height: 20,
                      color: AppTheme.statusColor(task.status),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: AppTheme.statusColor(task.status),
                      ),
                      //iconAlignment: IconAlignment.end,
                      onPressed: () {
                        task.status = task.status.nextStatus;
                        HiveService.updateObject(task);
                        callbackFunction();
                      },
                      // label: Text(task.status.nextStatusButtonText,
                      //     style: AppTheme.buttonTextStyle(
                      //         color: AppTheme.statusColor(task.status))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
