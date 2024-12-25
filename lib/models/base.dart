import 'package:task_brancher/models/status.dart';

abstract class Base {
  String id = ""; //идентификатор
  String parentId = ""; //идентификатор родителя
  String projectId = ""; //идентификатор проекта
  String title = ""; //название
  String description = ""; //описание
  String number = ""; //номер
  Status status; //статус
  late List<String> children; //дочерние элементы

  Base({
    this.id = "",
    required this.projectId,
    required this.parentId,
    required this.title,
    required this.description,
    required this.number,
    required this.children,
    this.status = Status.none,
  }) {
    if (id == "") id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  //Функция для преобразования объекта в json
  Map<String, dynamic> toJson();

  //Функция для сравнения объектов
  bool equals(Base? other) {
    if (other == null) return false;
    return id == other.id;
  }

  //Добавление подзадачи
  void addChild(Base model) {
    if (children.contains(model.id)) return;
    children.add(model.id);
  }

  //Удаление подзадачи
  void deleteChild(Base model) {
    children.remove(model.id);
  }

  //Получение количества подзадач
  int getChildCount() => children.length;

  //Проверка наличия родителя по заполненной id родителя
  bool haveParrent() => parentId != "";

  //Получение строки типа
  String getType() => runtimeType.toString();
}
