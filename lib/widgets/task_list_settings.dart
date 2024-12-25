import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

class TaskListSettings extends StatefulWidget {
  final VoidCallback? callbackMethod;

  //Конструктор
  TaskListSettings({super.key, this.callbackMethod});

  @override
  State<TaskListSettings> createState() => _TaskListSettingsState();
}

class _TaskListSettingsState extends State<TaskListSettings> {
  List<bool> selected = [];

  //Получить список настроек
  List<bool> getSettingsList() {
    final taskStatusList = DataBase.getSettings().taskStatusList;
    return List.generate(Status.values.length, (index) {
      return taskStatusList.contains(Status.values[index]) ? true : false;
    });
  }

  //Сохранить список настроек
  void saveSettingsList(List<bool> selected) {
    //получим текущие настройки
    Settings settings = DataBase.getSettings();

    //очистим текущий список
    settings.taskStatusList.clear();

    //заполним новым списком
    for (int i = 0; i < Status.values.length; i++) {
      if (selected[i]) {
        settings.taskStatusList.add(Status.values[i]);
      }
    }

    //сохраним изменения настроек
    DataBase.saveSettings(settings);

    //вызовем обновление списка задач
    widget.callbackMethod?.call();
  }

  @override
  void initState() {
    super.initState();
    //Исходные настройки списка
    selected = getSettingsList();
  }

  @override
  void dispose() {
    super.dispose();
    //Сохранить изменения в настройках списка
    saveSettingsList(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Настройки списка задач',
          style: AppTheme.appTextStyle('Body'),
          textAlign: TextAlign.start,
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: Status.values.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: selected[index],
                  onChanged: (bool? value) {
                    selected[index] = value!;
                    setState(() {});
                  },
                  title: Text(Status.values[index].title),
                );
              }),
        ),
      ],
    );
  }
}
