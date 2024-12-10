class Base {
  String id = ""; //идентификатор
  String parentId = ""; //идентификатор родителя
  String projectId = ""; //идентификатор проекта
  String title = ""; //название
  String description = ""; //описание
  String number = ""; //номер
  late List<String> children; //дочерние элементы

  Base({
    this.id = "",
    required this.projectId,
    required this.parentId,
    required this.title,
    required this.description,
    required this.number,
    required this.children,
  }) {
    if (id == "") id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  //Фабрика для создания объекта из json
  factory Base.fromJson(Map<dynamic, dynamic> json) {
    return Base(
      id: json['id'],
      projectId: json['projectId'],
      parentId: json['parentId'],
      title: json['title'],
      description: json['description'],
      number: json['number'],
      children: json['children'],
    );
  }

  //Фабрика для создания пустого объекта
  factory Base.empty({required String projectId, required String parentId}) {
    var newId = DateTime.now().millisecondsSinceEpoch.toString();
    return Base(
      id: newId,
      projectId: projectId,
      parentId: parentId,
      title: "",
      description: "",
      number: "",
      children: [],
    );
  }

  //Функция для преобразования объекта в json
  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'parentId': parentId,
        'title': title,
        'description': description,
        'number': number,
        'children': children,
      };

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
  int getChildrenCount() {
    return children.length;
  }

  //Проверка наличия родителя по заполненной id родителя
  bool haveParrent() => parentId != "";

  //Получение строки типа
  String getType() => runtimeType.toString();
}
