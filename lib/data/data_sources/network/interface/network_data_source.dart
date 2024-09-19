import 'package:kpi_drive_kanban/domain/entities/task/task.dart';

abstract class NetworkDataSource {
  Future<List<Task>> getTasks();
  Future<bool> saveTaskChanges(Task task);
}
