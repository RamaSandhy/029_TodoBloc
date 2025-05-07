part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class TodoEventAdd extends TodoEvent {
  final String title;
  final DateTime date;

  TodoEventAdd({required this.title, required this.date});
}

final class TodoEventComplete extends TodoEvent {
  final int index;

  TodoEventComplete({required this.index});
}

final class TodoSelectDate extends TodoEvent {
  final DateTime date;

  TodoSelectDate({required this.date});
}