import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_drive_kanban/domain/repository/products_data_repository.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/bloc/kanban_event.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/bloc/kanban_state.dart';

class KanbanBloc extends Bloc<KanbanEvent, KanbanState> {
  final ProductsDataRepository productsDataRepository;

  KanbanBloc(this.productsDataRepository) : super(const KanbanState()) {
    on<KanbanTasksFetched>(_onKanbanTasksFetched);
    on<KanbanSaveTaskChanges>(_onKanbanSaveTaskChanges);
  }

  Future<void> _onKanbanTasksFetched(
      KanbanTasksFetched event, Emitter<KanbanState> emit) async {
    try {
      //emit(state.copyWith(status: KanbanStatus.initial));
      final tasks = await productsDataRepository.getTasks();
      emit(state.copyWith(tasks: tasks, status: KanbanStatus.success));
    } catch (e) {
      print(e.runtimeType);
      emit(state.copyWith(
          status: KanbanStatus.failure, userMessage: e.toString()));
    }
  }

  FutureOr<void> _onKanbanSaveTaskChanges(
    KanbanSaveTaskChanges event,
    Emitter<KanbanState> emit,
  ) async {
    try {
      final isSaved = await productsDataRepository.saveTaskChanges(event.task);
      if(isSaved) {
        emit(
          state.copyWith(status: KanbanStatus.updated, userMessage: 'Updated'),
        );
      } else {
        throw Exception(['Error occurred']);
      }
    } catch (e) {
      emit(
        state.copyWith(status: KanbanStatus.failure, userMessage: e.toString()),
      );
    }
  }
}
