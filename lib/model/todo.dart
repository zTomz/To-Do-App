
import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  bool finished;
  @HiveField(2)
  final DateTime createdDate;

  ToDo({
    required this.title,
    required this.finished,
    required this.createdDate,
  });
}
