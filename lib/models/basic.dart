class Basic {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String title = "";
  String description = "";
  String parentId = "";

  Basic(
      {required this.title, required this.description, required this.parentId});
}
