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
              const Text(
                'Todo List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Selected Date'),
                      BlocBuilder<TodoBloc, TodoState>(
                    builder: (context, state) {
                      if (state is TodoLoaded) {
                        if (state.selectedDate == null) {
                          return const Text(
                            'No date selected',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return Text(
                          '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
                          style: const TextStyle(fontSize: 14),
                        );
                      }
                      return const Text(
                        'No date selected',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100), // batas atas lebih besar dari hari ini
                        )
                        .then((selectedDate) {
                        if (selectedDate != null) {
                          context.read<TodoBloc>().add(
                            TodoSelectDate(date: selectedDate),
                          );
                          }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              Form(
                key: _key,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
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
                  if (_key.currentState!.validate()) {
                    final state = context.read<TodoBloc>().state;
                    if (state is TodoLoaded) {
                      context.read<TodoBloc>().add(
                        TodoEventAdd(
                          title: _controller.text,
                          date: state.selectedDate!,
                        ),
                      );
                      _controller.clear();
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
                                  Text('${todo.date!.day}/${todo.date!.month}/${todo.date!.year}'),
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