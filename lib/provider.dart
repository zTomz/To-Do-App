import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/model/todo.dart';

final toDoProvider = StateProvider<List<ToDo>>((ref) {
  final toDoBox = Hive.box<ToDo>("todos");
  List<ToDo> todos = [];
  toDoBox.values.forEach((todo) => todos.add(todo));
  return todos;
});
final addToDoProvider = StateProvider((ref) => false);
