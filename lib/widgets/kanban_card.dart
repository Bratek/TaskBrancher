import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class KanbanCard extends StatelessWidget {
  final Task task;
  final VoidCallback callbackFunction;

  const KanbanCard({super.key, required this.task, required this.callbackFunction});

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
            child: Text(task.number, style: AppTheme.appTextStyle('BodyLight')),
          ),

          //Разделитель
          Divider(thickness: 1, color: AppTheme.statusColor(task.status), indent: 5, endIndent: 5),
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
                    style: AppTheme.appTextStyle('BodyLight')),
                //Отступ
                const SizedBox(height: 5),

                //Кнопка изменения статуса
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Кнопка перехода в список подзадач для этой задачи
                    (task.status != Status.none && task.status != Status.inprogress)
                        ? const SizedBox(width: 24)
                        : IconButton(
                            icon: Image.asset(
                              'assets/images/tasks.png',
                              width: 24,
                              height: 24,
                              color: AppTheme.statusColor(task.status),
                            ),
                            onPressed: () {
                              if (global.currentProject != null) {
                                global.navigateToScreen(context, routeName: '/tasks', arguments: task);
                                // Navigator.of(context)
                                //     .pushNamed('tasks', arguments: widget.project);
                              }
                            },
                          ),
                    const Expanded(
                        child: SizedBox(
                      width: 10,
                    )),

                    //Кнопка подменю выбора статуса
                    PopupMenuButton(
                      initialValue: task.status,
                      elevation: 8,
                      position: PopupMenuPosition.under,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(children: [
                        Icon(Icons.arrow_drop_down, color: AppTheme.statusColor(task.status)),
                        Text(
                          task.status.title,
                          style: AppTheme.statusButtonTextStyle(task.status),
                        ),
                      ]),
                      itemBuilder: (context) => global.appSettings.kanbanStatusList
                          .map(
                            (status) => PopupMenuItem(
                              value: status,
                              child: Text(
                                status.title,
                                style: AppTheme.statusButtonTextStyle(status),
                              ),
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        task.status = value;
                        DataBase.update(task);
                        callbackFunction();
                      },
                    ),

                    //Вертикальный разделитель
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      width: 1,
                      height: 20,
                      color: AppTheme.statusColor(task.status),
                    ),

                    //Кнопка для перехода с следующему статусу
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: AppTheme.statusColor(task.status),
                      ),
                      onPressed: () {
                        task.status = task.status.nextStatus;
                        DataBase.update(task);
                        callbackFunction();
                      },
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
