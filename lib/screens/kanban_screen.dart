import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class KanbanScreen extends StatefulWidget {
  final Project project;

  const KanbanScreen({super.key, required this.project});

  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  //Процедура обновления канбан списка после закрытия drawer меню
  void _onDrawerClosed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //Список задач для вывода в канбан
    List<Task> kanban = DataBase.getKanbanList(widget.project);
    //Получим словарь со списком задач для каждой колонки статуса
    Map<Status, List<Task>> statusColumns = spreadList(kanban);
    //Список статусов (колонок)
    List<Status> kanbanStatusList = statusColumns.keys.toList();

    var scrollController = ScrollController();

    return Scaffold(
      backgroundColor: AppTheme.appColor('Background'),

      //Шапка ****************************************************************
      appBar: AppBar(
        backgroundColor: AppTheme.appColor('Background'),
        leading: IconButton(
          onPressed: () {
            global.navigateToScreen(context, routeName: '/');
          },
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(widget.project.title, style: AppTheme.appTextStyle('Title')),
        // actions: [
        //   Builder(
        //     builder: (context) {
        //       return IconButton(
        //         icon: const Icon(Icons.settings),
        //         onPressed: () {
        //           Scaffold.of(context).openEndDrawer();
        //         },
        //       );
        //     },
        //   ),
        // ],
      ),
      // endDrawer: Drawer(
      //   child: SafeArea(
      //       child: Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(10),
      //         child: Text(
      //           "Настройки канбан списка",
      //           style: AppTheme.appTextStyle('Title'),
      //         ),
      //       ),
      //       const Divider(
      //         thickness: 1,
      //         color: Colors.grey,
      //         indent: 15,
      //         endIndent: 15,
      //       ),
      //       SizedBox(
      //         height: 350,
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 15),
      //           child: KanbanListSettings(callbackMethod: _onDrawerClosed),
      //         ),
      //       ),
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         child: Text(
      //           "ЗАКРЫТЬ",
      //           style: AppTheme.buttonTextStyle(color: AppTheme.appColor('OkButton')),
      //         ),
      //       ),
      //     ],
      //   )),
      // ),

      //Подвал ****************************************************************
      bottomNavigationBar: BottomAppBar(
        height: 64,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        color: AppTheme.appColor('Background2'),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.home, color: AppTheme.appColor('IconColor'), size: 24),
                onPressed: () {
                  global.navigateToScreen(context, routeName: '/');
                  //Navigator.pop(context);
                }),
            const SizedBox(width: 24),
            IconButton(
              icon: Image.asset(
                'assets/images/tasks.png',
                width: 24,
                height: 24,
                color: AppTheme.appColor('IconColor'),
              ),
              onPressed: () {
                if (global.currentProject != null) {
                  global.navigateToScreen(context, routeName: '/tasks');
                  // Navigator.of(context)
                  //     .pushNamed('tasks', arguments: widget.project);
                }
              },
            ),
          ],
        ),
      ),

      //Тело ******************************************************************
      body: Column(
        children: [
          //Разделитель
          Container(
            color: AppTheme.appColor('Accent3'),
            height: 2,
          ),
          Expanded(
            //child: PageView(controller: pageController,
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              controller: scrollController,
              interactive: true,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: kanbanStatusList.length,
                itemBuilder: (context, index) {
                  Status status = kanbanStatusList[index];
                  int nextStatusIndex = (index + 1 == kanbanStatusList.length) ? index : index + 1;
                  Status nextStatus = kanbanStatusList[nextStatusIndex];
                  return statusList(context, statusColumns[status]!, status, nextStatus);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  //Отрисовка списка задач с указанным статусом
  Widget statusList(BuildContext context, List<Task> taskList, Status status, Status nextStatus) {
    //получение ширины экрана
    var sizeWidth = MediaQuery.of(context).size.width;

    //ширина карточки списка в зависимости от ширины экрана
    var cardWidth = sizeWidth - 20;
    if (sizeWidth <= 904) {
      cardWidth = sizeWidth - 20;
    } else if (sizeWidth <= 1200) {
      cardWidth = (sizeWidth - 20) / 2;
    } else {
      cardWidth = (sizeWidth - 20) / 3;
    }

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      color: AppTheme.appColor('Background'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Заголовок столбца
          Container(
            height: 26,
            width: cardWidth,
            margin: const EdgeInsets.only(left: 10, right: 10),
            color: AppTheme.statusColor(status, isCard: true),
            child: Center(
              child: Text(status.columnStatusText, style: AppTheme.statusTextStyle(status).copyWith(fontSize: 18)),
            ),
          ),
          //Отступ
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              //shrinkWrap: true,
              //itemExtent: cardWidth,
              itemCount: taskList.length,
              itemBuilder: (context, index) => KanbanCard(
                task: taskList[index],
                nextStatus: nextStatus,
                callbackFunction: () => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Формирование списоков задач по статусам
  Map<Status, List<Task>> spreadList(kanban) {
    //Получим список статусов из настройки для канбана
    List<Status> kanbanStatusList = DataBase.getSettings().kanbanStatusList;

    //Создаем словарь со списком задач для каждого статуса
    Map<Status, List<Task>> statusColumns = {};
    for (var status in kanbanStatusList) {
      statusColumns[status] = [];
    }
    //Добавляем задачи в соответствующий стаусу список
    for (var task in kanban) {
      statusColumns[task.status]?.add(task);
    }
    return statusColumns;
  }
}
