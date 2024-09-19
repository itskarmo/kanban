import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_drive_kanban/domain/entities/task/task.dart';
import 'package:kpi_drive_kanban/domain/repository/products_data_repository.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/bloc/kanban_bloc.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/bloc/kanban_event.dart';
import 'package:kpi_drive_kanban/presentation/di/injector.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/bloc/kanban_state.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/view/widgets/kanban_desk.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KanbanBloc>(
          create: (BuildContext context) => KanbanBloc(
            i<ProductsDataRepository>(),
          )..add(KanbanTasksFetched()),
        ),
      ],
      child: Scaffold(
        body: BlocConsumer<KanbanBloc, KanbanState>(
          listener: (BuildContext context, KanbanState state) {
            if (state.status == KanbanStatus.updated ||
                state.status == KanbanStatus.failure) {
              final snackBar = SnackBar(
                content: Center(child: Text(state.userMessage)),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if(state.status == KanbanStatus.updated) {
                context.read<KanbanBloc>().add(KanbanTasksFetched());
              }
            }
          },
          //buildWhen: (oldState, newState) => oldState.tasks != newState.tasks,
          builder: (context, state) {
            if (state.status == KanbanStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Center(
                child: KanbanDesk(
                  tasks: state.tasks,
                  onMoveGroupItem: (
                    String groupId,
                    int fromIndex,
                    int toIndex,
                  ) {
                    context.read<KanbanBloc>().add(
                          KanbanSaveTaskChanges(
                            task: getTaskByParentIdAndOrder(
                              state.tasks,
                              groupId,
                              fromIndex,
                            ).copyWith(order: toIndex + 1),
                          ),
                        );
                  },
                  onMoveGroupItemToGroup: (String fromGroupId, int fromIndex,
                      String toGroupId, int toIndex) {
                    context.read<KanbanBloc>().add(
                          KanbanSaveTaskChanges(
                            task: getTaskByParentIdAndOrder(
                              state.tasks,
                              fromGroupId,
                              fromIndex,
                            ).copyWith(
                                parentId: int.parse(toGroupId), order: toIndex + 1),
                          ),
                        );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Task getTaskByParentIdAndOrder(List<Task> tasks, String parentId, int order) {
  return tasks.singleWhere(
    (task) => (task.parentId.toString() == parentId && task.order == order + 1),
  );
}
