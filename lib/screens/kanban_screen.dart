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
  @override
  Widget build(BuildContext context) {
    List<Task> kanban = DataBase.getKanbanList(widget.project);
    Map<String, List<Task>> statusColumns = spreadList(kanban);
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
        title:
            Text(widget.project.title, style: AppTheme.appTextStyle('Title')),
      ),

      //Плавающая кнопка  ****************************************************
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppTheme.appColor('Accent3'),
      //   elevation: 0,
      //   shape: const CircleBorder(),
      //   onPressed: () {},
      //   child: const Icon(
      //     Icons.swap_horiz,
      //     size: 24,
      //     color: Colors.white,
      //   ),
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
                icon: Icon(Icons.home,
                    color: AppTheme.appColor('IconColor'), size: 24),
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
              child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    statusList(context, statusColumns["none"]!, Status.none),
                    statusList(context, statusColumns["inprogress"]!,
                        Status.inprogress),
                    statusList(
                        context, statusColumns["verify"]!, Status.verify),
                    statusList(
                        context, statusColumns["completed"]!, Status.completed),
                    statusList(
                        context, statusColumns["calceled"]!, Status.calceled),
                  ]),
            ),
          )
        ],
      ),
    );
  }

  Widget statusList(BuildContext context, List<Task> tasksList, Status status) {
    var sizeWidth = MediaQuery.of(context).size.width;
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
              child: Text(status.columnStatusText,
                  style:
                      AppTheme.statusTextStyle(status).copyWith(fontSize: 18)),
            ),
          ),
          //Отступ
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              //shrinkWrap: true,
              //itemExtent: cardWidth,
              itemCount: tasksList.length,
              itemBuilder: (context, index) => KanbanCard(
                task: tasksList[index],
                callbackFunction: () => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Task>> spreadList(kanban) {
    List<Task> none = [];
    List<Task> inprogress = [];
    List<Task> verify = [];
    List<Task> completed = [];
    List<Task> calceled = [];
    List<Task> hidden = [];
    for (var task in kanban) {
      if (task.status == Status.none) {
        none.add(task);
      } else if (task.status == Status.inprogress) {
        inprogress.add(task);
      } else if (task.status == Status.verify) {
        verify.add(task);
      } else if (task.status == Status.completed) {
        completed.add(task);
      } else if (task.status == Status.calceled) {
        calceled.add(task);
      } else {
        hidden.add(task);
      }
    }
    return {
      "none": none,
      "inprogress": inprogress,
      "verify": verify,
      "completed": completed,
      "calceled": calceled,
      "hidden": hidden,
    };
  }
}
