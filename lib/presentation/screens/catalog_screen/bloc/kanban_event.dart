import 'package:kpi_drive_kanban/domain/entities/task/task.dart';

sealed class KanbanEvent {
  const KanbanEvent();
}

final class KanbanTasksFetched extends KanbanEvent {}

final class KanbanSaveTaskChanges extends KanbanEvent {
  final Task task;

  const KanbanSaveTaskChanges({required this.task});
}
