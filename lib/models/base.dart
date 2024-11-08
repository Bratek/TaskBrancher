class Base {
  String id = "";
  String parentId = "";
  String title = "";
  String description = "";
  String number = "";

  Base(
      {required this.title,
      required this.description,
      required this.parentId,
      required this.number,
      this.id = ""}) {
    if (id == "") id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  factory Base.fromJson(Map<dynamic, dynamic> json) {
    return Base(
      id: json['id'],
      parentId: json['parentId'],
      title: json['title'],
      description: json['description'],
      number: json['number'],
    );
  }

  Map<String, dynamic> tojson() => {
        'id': id,
        'parentId': parentId,
        'title': title,
        'description': description,
        'number': number,
      };
}
