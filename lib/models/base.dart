class Base {
  String id = "";
  String parentId = "";
  String title = "";
  String description = "";
  String number = "";

  Base({
    required this.title,
    required this.description,
    required this.parentId,
    required this.number,
    this.id = "",
  }) {
    if (id == "") id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  //Фабрика для создания объекта из json
  factory Base.fromJson(Map<dynamic, dynamic> json) {
    return Base(
      id: json['id'],
      parentId: json['parentId'],
      title: json['title'],
      description: json['description'],
      number: json['number'],
    );
  }

  factory Base.Empty(String parentId) {
    var newId = DateTime.now().millisecondsSinceEpoch.toString();
    return Base(
      id: newId,
      parentId: parentId,
      title: "",
      description: "",
      number: "",
    );
  }

  //Функция для преобразования объекта в json
  Map<String, dynamic> tojson() => {
        'id': id,
        'parentId': parentId,
        'title': title,
        'description': description,
        'number': number,
      };

  //Функция для сравнения объектов
  bool equals(Base? other) {
    if (other == null) return false;
    return id == other.id;
  }
}
