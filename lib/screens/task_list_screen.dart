import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:hive/hive.dart';
import 'package:task_brancher/models/base.dart';
import 'package:task_brancher/models/task.dart';
import 'package:task_brancher/services/hive_service.dart';
import 'package:task_brancher/widgets/task_card.dart';

class TasksListScreen extends StatefulWidget {
  final Base parent;

  const TasksListScreen({super.key, required this.parent});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = HiveService.getChildren(widget.parent.id);

    return Scaffold(
      // ignore: prefer_const_constructors
      backgroundColor: Color(0xFFF0EDED),
      appBar: AppBar(
        title: Text(
          "${widget.parent.number}. ${widget.parent.title}",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      // опция для выталкивания клавиатурой bottomSheet виджета
      resizeToAvoidBottomInset: true,
      // плавающая кнопка добавления проекта
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF45D900),
        onPressed: () async {
          var newTask = Task(
              parentId: widget.parent.id,
              title: "",
              description: "",
              number:
                  "${widget.parent.number}.${(tasks.length + 1).toString()}");
          // Показать форму для добавления проекта
          final result = await taskEditForm(context, newTask);
          if (result) {
            // Добавить проект
            //tasks.add(newTask);
            HiveService.create(newTask);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
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
                  HiveService.delete(tasks[index]);
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
                    final result = await taskEditForm(context, tasks[index]);
                    if (result) {
                      //Сохранить изменения
                      HiveService.update(tasks[index]);
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
                // Открыть окно вложенных задач
                Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: TasksListScreen(parent: tasks[index]),
                    ));
                // MaterialPageRoute(
                //     builder: (context) =>
                //         TasksListScreen(parent: tasks[index])));
              },
            ),
          );
        },
      ),
    );
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
                        child: const Text(
                          'Отмена',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        onPressed: () async {
                          result = false;
                          // закрыть форму
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(color: Colors.green, fontSize: 18),
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
