class ModalTaskCard {
  int? taskId;
  int isfinished;
  String title;
  String description;
  String date;
  ModalTaskCard(
      {this.taskId,
      required this.title,
      required this.description,
      required this.date,
      required this.isfinished});

  Map<String, dynamic> taskMap() {
    return {
      // 'taskId': taskId,
      'isfinished': isfinished,
      'title': title,
      'description': description,
      'date': date
    };
  }
}
