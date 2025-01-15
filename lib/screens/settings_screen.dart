import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, bool> taskSettingsMap = {};
  Map<String, bool> kanbanSettingsMap = {};

  void initSettingsMap() {
    List<Status> taskStatusList = DataBase.getSettings().taskStatusList;
    List<Status> kanbanStatusList = DataBase.getSettings().kanbanStatusList;

    for (var status in Status.values) {
      taskSettingsMap[status.name] = taskStatusList.contains(status);
      kanbanSettingsMap[status.name] = kanbanStatusList.contains(status);
    }
  }

  void saveSettings() {
    List<Status> taskStatusList = [];
    List<Status> kanbanStatusList = [];

    for (var entry in taskSettingsMap.entries) {
      if (entry.value) {
        taskStatusList.add(Status.values.byName(entry.key));
      }
    }

    for (var entry in kanbanSettingsMap.entries) {
      if (entry.value) kanbanStatusList.add(Status.values.byName(entry.key));
    }

    DataBase.saveSettings(
      Settings(
        taskStatusList: taskStatusList,
        kanbanStatusList: kanbanStatusList,
      ),
    );
  }

  @override
  void initState() {
    initSettingsMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      //Для контроля системной кнопки назад
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => saveAndNavigationPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appColor('Background'),
          //centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            // ignore: prefer_const_constructors
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Настройки",
            style: AppTheme.appTextStyle('Title'),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Настройки списка задач",
                style: AppTheme.appTextStyle('Title'),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: taskSettingsMap.entries.map((entry) {
                      return Row(
                        children: [
                          Checkbox(
                            value: entry.value,
                            onChanged: (value) {
                              setState(() {
                                taskSettingsMap[entry.key] = value ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            statusNameFromString(entry.key),
                            style: AppTheme.appTextStyle('BodyLight'),
                          ),
                        ],
                      );
                    }).toList()),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Настройки канбан колонок",
                style: AppTheme.appTextStyle('Title'),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: kanbanSettingsMap.entries.map((entry) {
                      return Row(
                        children: [
                          Checkbox(
                            value: entry.value,
                            onChanged: (value) {
                              setState(() {
                                kanbanSettingsMap[entry.key] = value ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            statusNameFromString(entry.key),
                            style: AppTheme.appTextStyle('BodyLight'),
                          ),
                        ],
                      );
                    }).toList()),
              ),
            ),
            TextButton(
              onPressed: () {
                saveAndNavigationPop(context);
              },
              child: Text(
                "СОХРАНИТЬ",
                style: AppTheme.buttonTextStyle(color: AppTheme.appColor('OkButton')),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void saveAndNavigationPop(BuildContext context) {
    saveSettings();
    global.navigateToScreen(context, routeName: '/');
  }
}
