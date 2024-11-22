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
    List<Task> tasks = HiveService.getTasksForKanban();

    return Scaffold(
      backgroundColor: AppTheme.appColor('Background'),
      appBar: AppBar(
        backgroundColor: AppTheme.appColor('Background'),
        centerTitle: true,
        title: Text("Канбан", style: AppTheme.appTextStyle('AppBar')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.appColor('Accent3'),
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          Icons.swap_horiz,
          size: 24,
          color: Colors.white,
        ),
      ),
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
                  Navigator.pop(context);
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
                  Navigator.of(context)
                      .pushNamed('tasks', arguments: widget.project);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             TasksListScreen(parent: global.currentProject!)));
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 3,
            color: AppTheme.appColor('Accent3'),
          ),
          //Отступ
          const SizedBox(height: 10),
          //Список проектов
          Expanded(
            child: Text("Канбан", style: AppTheme.appTextStyle('Title')),
          ),
        ],
      ),
    );
  }
}
