import 'package:equatable/equatable.dart';
import 'package:kpi_drive_kanban/domain/entities/task/task.dart';

enum KanbanStatus { initial, success, failure, inProgress, updated}

final class KanbanState extends Equatable {
  final KanbanStatus status;
  final String userMessage;
  final List<Task> tasks;

  const KanbanState({
    this.status = KanbanStatus.initial,
    this.userMessage = '',
    this.tasks = const <Task>[],
  });

  KanbanState copyWith({
    KanbanStatus? status,
    String? userMessage,
    List<Task>? tasks,
  }) {
    return KanbanState(
      status: status ?? this.status,
      userMessage: userMessage ?? this.userMessage,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  String toString() {
    return '''KanbanState { status: $status, userMessage: $userMessage, tasks: ${tasks.length} }''';
  }

  @override
  List<Object> get props => [status, userMessage, tasks];
}
