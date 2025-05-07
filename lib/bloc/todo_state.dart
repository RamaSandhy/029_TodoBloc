part of 'todo_bloc.dart';

sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoLoaded extends TodoState {
  final List<Todo> todos;
  DateTime? selectedDate;

  TodoLoaded({
    required this.todos, required this.selectedDate});
}
