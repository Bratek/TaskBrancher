import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class TasksListScreen extends StatefulWidget {
  final Base parent;

  const TasksListScreen({super.key, required this.parent});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  Base? parent;

  @override
  void initState() {
    super.initState();
    //Задаем текущий проект как первоначальноезначение родителя для списка
    parent = widget.parent;
  }

  void hundlerCreate(Task? task) {
    if (task != null) {
      DataBase.executeMetod(task, CRUD.create);
    }
    setState(() {});
  }

  void hundlerUpdate(Task? task) {
    if (task != null) {
      DataBase.executeMetod(task, CRUD.update);
    }
    setState(() {});
  }

  void _onDrawerClosed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = DataBase.getTasksList(parent!);
    List<Status> taskStatusList = DataBase.getSettings().taskStatusList;

    return PopScope(
      //Для контроля системной кнопки назад
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => goBackScreen(context),
      child: Scaffold(
        // Цвет фона
        backgroundColor: AppTheme.appColor('Background'),
        // опция для выталкивания клавиатурой bottomSheet виджета
        resizeToAvoidBottomInset: true,
        //Отключаем открытие drawer меню по свайпу
        endDrawerEnableOpenDragGesture: false,
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
          title: Text(
            "Список подзадач",
            style: AppTheme.appTextStyle('Title'),
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TaskListSettings(callbackMethod: _onDrawerClosed),
            ),
          ),
        ),
        //Плавающая кнопка ******************************************************
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.appColor('Accent2'),
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () async {
            //Разрешить создавать подзадачи только для статуса "Новый" или "В работе" родительской задачи
            if (parent is Task) {
              Task parentTask = parent as Task;
              if (parentTask.status != Status.none && parentTask.status != Status.inprogress) {
                return;
              }
            }

            var newTask = Task(
                parentId: parent!.id,
                projectId: parent!.projectId,
                title: "",
                description: "",
                children: [],
                number: "${parent!.number}.${(tasks.length + 1).toString()}");
            // Показать форму для добавления задачи
            appBottomSheet(
                context,
                taskEditForm(
                  context,
                  newTask,
                  // (Task? task) {
                  //   if (task != null) {
                  //     DataBase.create(task);
                  //   }
                  //   setState(() {});
                  //   return null;
                  // },
                  hundlerCreate,
                ));
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
                    //Переход на главную
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
                    //Переход на канбан
                    global.navigateToScreen(context, routeName: '/kanban');
                  }
                },
              ),
            ],
          ),
        ),

        //Центральная часть экрана **********************************************
        body: Column(
          children: [
            //Разделитель
            Container(
              color: AppTheme.appColor('Accent2'),
              height: 2,
            ),
            //Родитель
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                "${parent!.number}. ${parent!.title}",
                textAlign: TextAlign.start,
                style: AppTheme.appTextStyle('Body'),
              ),
            ),
            //Список подзадач
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  // Пропустить карточку если ее нет в настройках
                  if (taskStatusList.contains(tasks[index].status) == false) {
                    return Container();
                  }

                  // Выводим карточку задачи
                  return Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(motion: const BehindMotion(), children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Удалить',
                        onPressed: (context) async {
                          // Удалить задачу
                          bool result = await confirmDialog(context,
                              title: "Удалить задачу?",
                              message: "При удалении задачи, будут удалены все его подзадачи.",
                              okButtonText: "Удалить",
                              cancelButtonText: "Отмена");

                          if (!result) {
                            return;
                          }
                          DataBase.delete(tasks[index]);
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
                          onPressed: (context) {
                            // Показать форму для редактирования
                            appBottomSheet(
                              context,
                              taskEditForm(
                                context,
                                tasks[index],
                                hundlerUpdate,
                              ),
                              // taskEditForm(
                              //   context,
                              //   tasks[index],
                              //   (Task? task) {
                              //     if (task != null) {
                              //       //Обновить список
                              //       DataBase.update(task);
                              //     }
                              //     setState(() {});
                              //     return null;
                              //   },
                            );
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
      parent = DataBase.getObjectById(parent!.parentId);
      setState(() {});
    }
  }

  void appBottomSheet(
    BuildContext context,
    WidgetBuilder body,
  ) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: body,
    );
  }

  WidgetBuilder taskEditForm(
    BuildContext context,
    Task task,
    Function(Task? task) callbackFunction,
  ) {
    return (BuildContext context) {
      //контроллеры для ввода c установленными начальными значениями
      final titleController = TextEditingController(text: task.title);
      final descriptionController = TextEditingController(text: task.description);
      //отрисовываем виджеты формы
      return Container(
        height: 300,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom), // нижний отступ для отталкивания от клавиатуры
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(
                  child: Text(
                    'ОТМЕНА',
                    style: AppTheme.buttonTextStyle(color: AppTheme.appColor('CancelButton')),
                  ),
                  onPressed: () {
                    //result = false;
                    callbackFunction(null);
                    // закрыть форму
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'СОХРАНИТЬ',
                    style: AppTheme.buttonTextStyle(color: AppTheme.appColor('OkButton')),
                  ),
                  onPressed: () {
                    // Сохранить изменения
                    task.title = titleController.text;
                    task.description = descriptionController.text;
                    //result = true;
                    callbackFunction(task);
                    // закрыть форму
                    Navigator.pop(context);
                  },
                ),
              ]),
            ],
          ),
        ),
      );
    };
  }
}
