import 'package:dio/dio.dart';
import 'package:kpi_drive_kanban/domain/entities/task/task.dart';
import 'package:kpi_drive_kanban/global_variables.dart';
import 'interface/network_data_source.dart';

class NetworkDataSourceImpl implements NetworkDataSource {
  final dio = Dio();

  @override
  Future<List<Task>> getTasks() async {
    final formData = FormData.fromMap(
      {
        'period_start': '2024-09-18',
        'period_end': '2024-10-18',
        'period_key': 'month',
        'requested_mo_id': '478',
        'behaviour_key': 'task,kpi_task',
        'with_result': 'false',
        'response_fields': 'name,indicator_to_mo_id,parent_id,order',
        'auth_user_id': '2',
      },
    );
    List<Task> data = [];
    try {
      final r = await dio.post(
        'https://development.kpi-drive.ru/_api/indicators/get_mo_indicators',
        data: formData,
      );
      if (r.statusCode == 200) {
        final rows = (r.data['DATA']['rows'] as List);
        for (Map<String, dynamic> row in rows) {
          data.add(Task.fromJson(row));
        }
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveTaskChanges(Task task) async {
    print(task.indicatorToMoId);
    final formData = FormData.fromMap(
      {
        'period_start': '2024-09-18',
        'period_end': '2024-10-18',
        'period_key': 'month',
        'indicator_to_mo_id': task.indicatorToMoId,
        'field_name': 'parent_id',
        'field_value': task.parentId,
        'auth_user_id': '2',
      },
    );
    formData.fields
      ..add(const MapEntry('field_name', 'order'))
      ..add(MapEntry('field_value', task.order.toString()));

    try {
      final r = await dio.post(
        'https://development.kpi-drive.ru/_api/indicators/save_indicator_instance_field',
        data: formData,
      );
      if (r.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  NetworkDataSourceImpl() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
  }
}
