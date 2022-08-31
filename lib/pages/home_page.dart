import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:to_do_app/model/todo.dart';
import 'package:to_do_app/provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  TextEditingController todoController = TextEditingController();
  final toDoBox = Hive.box<ToDo>("todos");

  void syncWithDatabase(List<ToDo> todos) async {
    await toDoBox.clear();
    await toDoBox.addAll(todos);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addToDo = ref.watch(addToDoProvider);
    final todos = ref.watch(toDoProvider);

    Size size = MediaQuery.of(context).size;

    syncWithDatabase(todos);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: const [
                    Text(
                      "To Do´s",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        MSHCheckbox(
                          size: 20,
                          checkedColor: const Color.fromARGB(255, 255, 82, 82),
                          value: todos[index].finished,
                          onChanged: (newValue) async {
                            ref.read(toDoProvider.notifier).update((state) => [
                                  for (ToDo todo in todos)
                                    if (todo.createdDate ==
                                        todos[index].createdDate)
                                      ToDo(
                                        title: todo.title,
                                        finished: !todo.finished,
                                        createdDate: todo.createdDate,
                                      )
                                    else
                                      todo
                                ]);
                          },
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: size.width - 200,
                          child: Text(
                            "${todos[index].title}, ${todos[index].createdDate.day}.${todos[index].createdDate.month}.${todos[index].createdDate.year}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ref.read(toDoProvider.notifier).state = todos
                                .where((todo) =>
                                    todo.createdDate !=
                                    todos[index].createdDate)
                                .toList();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: addToDo ? 200 : 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 82, 82),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: () {
                    if (addToDo) {
                      if (todoController.text.replaceAll(" ", "") != "") {
                        ref.read(toDoProvider.notifier).state.add(
                              ToDo(
                                title: todoController.text,
                                finished: false,
                                createdDate: DateTime.now(),
                              ),
                            );

                        todoController.text = "";
                      }
                    }

                    ref.read(addToDoProvider.notifier).state =
                        !ref.read(addToDoProvider.notifier).state;
                  },
                  child: addToDo
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: todoController,
                              ),
                            ),
                            const Icon(Icons.add)
                          ],
                        )
                      : const Center(
                          child: Icon(Icons.add),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
