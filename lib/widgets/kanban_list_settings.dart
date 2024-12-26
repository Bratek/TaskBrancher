import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

class KanbanListSettings extends StatefulWidget {
  final VoidCallback? callbackMethod;

  const KanbanListSettings({super.key, this.callbackMethod});

  @override
  State<KanbanListSettings> createState() => _KanbanListSettingsState();
}

class _KanbanListSettingsState extends State<KanbanListSettings> {
  List<bool> selected = [];

  //Получить список настроек
  List<bool> getSettingsList() {
    final kanbanStatusList = DataBase.getSettings().kanbanStatusList;
    return List.generate(Status.values.length, (index) {
      return kanbanStatusList.contains(Status.values[index]) ? true : false;
    });
  }

  //Сохранить список настроек
  void saveSettingsList(List<bool> selected) {
    //получим текущие настройки
    Settings settings = DataBase.getSettings();

    //очистим текущий список
    settings.kanbanStatusList.clear();

    //заполним новым списком
    for (int i = 0; i < Status.values.length; i++) {
      if (selected[i]) {
        settings.kanbanStatusList.add(Status.values[i]);
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
    return ListView.builder(
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
      },
    );
  }
}
