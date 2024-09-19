import 'package:kpi_drive_kanban/data/data_sources/network/interface/network_data_source.dart';
import 'package:kpi_drive_kanban/domain/entities/task/task.dart';
import 'package:kpi_drive_kanban/domain/repository/products_data_repository.dart';

class ProductsDataRepositoryImpl implements ProductsDataRepository {
  final NetworkDataSource _networkDataSource;

  ProductsDataRepositoryImpl(this._networkDataSource);

  @override
  Future<List<Task>> getTasks() async => await _networkDataSource.getTasks();

  @override
  Future<bool> saveTaskChanges(Task task) async =>
      await _networkDataSource.saveTaskChanges(task);
}
