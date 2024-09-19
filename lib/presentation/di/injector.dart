import 'package:get_it/get_it.dart';
import 'package:kpi_drive_kanban/data/data_sources/network/interface/network_data_source.dart';
import 'package:kpi_drive_kanban/data/data_sources/network/network_data_source_web_impl.dart';
import 'package:kpi_drive_kanban/data/data_sources/repositories/products_data_repository_impl.dart';
import 'package:kpi_drive_kanban/domain/repository/products_data_repository.dart';

GetIt get i => GetIt.instance;

Future<void> initInjector() async {
  i.registerSingleton<NetworkDataSource>(
    NetworkDataSourceImpl(),
  );
  i.registerSingleton<ProductsDataRepository>(
    ProductsDataRepositoryImpl(i.get()),
  );
}
