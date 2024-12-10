import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class TasksListScreen extends StatefulWidget {
  final Project project;

  const TasksListScreen({super.key, required this.project});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  Base? parent;

  @override
  void initState() {
    super.initState();
    //Задаем текущий проект как первоначальноезначение родителя для списка
    parent = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = HiveService.getTasksList(parent!);

    return PopScope(
      //Для контроля системной кнопки назад
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => goBackScreen(context),
      child: Scaffold(
        // Цвет фона
        backgroundColor: AppTheme.appColor('Background'),
        // опция для выталкивания клавиатурой bottomSheet виджета
        resizeToAvoidBottomInset: true,

        //Шапка ****************************************************************
        appBar: AppBar(
          backgroundColor: AppTheme.appColor('Background'),
          //centerTitle: true,
          leading: IconButton(
            onPressed: () {
              goBackScreen(context);
            },
            // ignore: prefer_const_constructors
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Список подзадач",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ),

        //Плавающая кнопка ******************************************************
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.appColor('Accent2'),
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () async {
            var newTask = Task(
                parentId: parent!.id,
                projectId: widget.project.id,
                title: "",
                description: "",
                children: [],
                number: "${parent!.number}.${(tasks.length + 1).toString()}");
            // Показать форму для добавления задачи
            final result = await taskEditForm(context, newTask);
            if (result) {
              HiveService.createObject(newTask);
              setState(() {});
            }
          },
          child: const Icon(
            Icons.add,
            size: 24,
            color: Colors.white,
          ),
        ),

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
                  icon: Icon(
                    Icons.home,
                    color: AppTheme.appColor('IconColor'),
                    size: 24,
                  ),
                  onPressed: () {
                    //Navigator.pop(context);
                    global.navigateToScreen(context, routeName: '/home');
                  }),
              const SizedBox(width: 24),
              IconButton(
                icon: Image.asset(
                  'assets/images/kanban.png',
                  width: 24,
                  height: 24,
                  color: AppTheme.appColor('IconColor'),
                ),
                onPressed: () {
                  if (global.currentProject != null) {
                    global.navigateToScreen(context, routeName: '/kanban');
                    // Navigator.of(context)
                    //     .pushNamed('/kanban', arguments: widget.project);
                  }
                },
              ),
            ],
          ),
        ),

        //Центральная часть экрана **********************************************
        body: Column(
          children: [
            Container(
              color: AppTheme.appColor('Accent2'),
              height: 3,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                "${parent!.number}. ${parent!.title}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  
                  // Пропустить карточку если статус задачи "Скрыто"
                  if (tasks[index].status == Status.hidden) {
                    return Container();
                  }
                  // Выводим карточку задачи
                  return Slidable(
                    key: ValueKey(index),
                    startActionPane:
                        ActionPane(motion: const BehindMotion(), children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Удалить',
                        onPressed: (context) {
                          // Удалить проект
                          //tasks.removeAt(index);
                          HiveService.deleteObject(tasks[index]);
                          //Обновить список
                          setState(() {});
                        },
                      ),
                    ]),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Изменить',
                          onPressed: (context) async {
                            final result =
                                await taskEditForm(context, tasks[index]);
                            if (result) {
                              //Сохранить изменения
                              HiveService.updateObject(tasks[index]);
                              // Обновить список
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: TaskCard(task: tasks[index]),
                      onTap: () {
                        // Переход к вложенному списку задач
                        parent = tasks[index];
                        setState(() {});

                        //Navigator.of(context).pushNamed('/tasks', arguments: tasks[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goBackScreen(BuildContext context) {
    if (parent!.parentId == "") {
      global.navigateToScreen(context, routeName: '/');
    } else {
      //Переход к предыдущему списку путем указания родителя для родителя этого списка
      parent = HiveService.getObjectById(parent!.parentId);
      setState(() {});
    }
  }

  Future<bool> taskEditForm(BuildContext context, Task task) async {
    //контроллеры для ввода c установленными начальными значениями
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    bool result = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        //отрисовываем виджеты формы
        return Container(
          height: 300,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom), // нижний отступ для отталкивания от клавиатуры
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  //autofocus: true,
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Заголовок',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
                const SizedBox(height: 10),

                //кнопки
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text(
                          'Отмена',
                          style: TextStyle(
                              color: AppTheme.appColor('CancelButton'),
                              fontSize: 18),
                        ),
                        onPressed: () async {
                          result = false;
                          // закрыть форму
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                              color: AppTheme.appColor('OkButton'),
                              fontSize: 18),
                        ),
                        onPressed: () {
                          // Сохранить изменения
                          task.title = titleController.text;
                          task.description = descriptionController.text;
                          result = true;
                          // закрыть форму
                          Navigator.pop(context);
                        },
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );

    return result;
  }
}
