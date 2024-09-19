import 'package:kpi_drive_kanban/domain/entities/task/task.dart';

abstract class ProductsDataRepository {
  Future<List<Task>> getTasks();
  Future<bool> saveTaskChanges(Task task);
}
