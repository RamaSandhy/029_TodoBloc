import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    final _controller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Todo List'),
              Row(
                children: [
                  Column(
                    children: [
                      Text('Selected Date'),
                      BlocBuilder<TodoBloc, TodoState>(
                        builder: (context, state) {
                          if (state is TodoLoaded) {
                            if (state.selectedDate == null) {
                              return Text('No date selected');
                            }
                            return Text('${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year}');
                          }
                          return Text('No date selected');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 36.0),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),
                        ).then((selectedDate) {
                        if (selectedDate != null) {
                          context.read<TodoBloc>().add(
                            TodoSelectDate(date: selectedDate),
                          );
                          }
                      });
                    },
                    child: Text('Select Date'),
                  ),
                ],
              ),
              Form(
                key: key,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Input Task',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    final state = context.read<TodoBloc>().state;
                    if (state is TodoLoaded) {
                      context.read<TodoBloc>().add(
                        TodoEventAdd(
                          title: controller.text,
                          date: state.selectedDate!,
                        ),
                      );
                      controller.clear();
                      state.selectedDate = null;
                    }
                  }
                },
                child: Text('Tambah'),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoLoaded) {
                      if (state.todos.isEmpty) {
                        return Center(child: Text('Todo list is empty'));
                      }
                      return ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(todo.title),
                              subtitle: Row(
                                children: [
                                  Text('${todo.date.day}/${todo.date.month}/${todo.date.year}'),
                                ],
                              ),
                              trailing: Checkbox(
                                value: todo.isCompleted,
                                onChanged: (value) {
                                  context.read<TodoBloc>().add(
                                    TodoEventComplete(index: index),
                                  );
                                },
                              ),
                              tileColor: todo.isCompleted
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        },
                      );
                    }

                    return Center(child: Text('No todos available'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

