import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:kpi_drive_kanban/domain/entities/task/task.dart';

typedef OnMoveGroupItem = void Function(
  String groupId,
  int fromIndex,
  int toIndex,
);

typedef OnMoveGroupItemToGroup = void Function(
  String fromGroupId,
  int fromIndex,
  String toGroupId,
  int toIndex,
);

class KanbanDesk extends StatefulWidget {
  final List<Task> tasks;

  final OnMoveGroupItem onMoveGroupItem;

  final OnMoveGroupItemToGroup onMoveGroupItemToGroup;

  const KanbanDesk({
    super.key,
    required this.tasks,
    required this.onMoveGroupItem,
    required this.onMoveGroupItemToGroup,
  });

  @override
  State<KanbanDesk> createState() => _KanbanDeskState();
}

class _KanbanDeskState extends State<KanbanDesk> {
  late AppFlowyBoardScrollController boardController;

  late AppFlowyBoardController controller;

  @override
  void initState() {
    super.initState();
    controller = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move item from $fromIndex to $toIndex');
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        debugPrint('MoveGroupItem $groupId:$fromIndex to $groupId:$toIndex');
        widget.onMoveGroupItem(groupId, fromIndex, toIndex);
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint(
            'MoveGroupItemToGroup $fromGroupId:$fromIndex to $toGroupId:$toIndex');
        widget.onMoveGroupItemToGroup(
            fromGroupId, fromIndex, toGroupId, toIndex);
      },
    );
    boardController = AppFlowyBoardScrollController();
    final groups = <String>{};
    for (var task in widget.tasks) {
      groups.add(task.parentId.toString());
    }
    for (final groupId in groups) {
      final items = widget.tasks
          .where((task) => task.parentId.toString() == groupId)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      controller.addGroup(
        AppFlowyGroupData(
          id: groupId,
          name: groupId,
          items: List.generate(
            items.length - 1,
            (int index) => TextItem(
              items[index].name,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFlowyBoard(
      headerBuilder: (context, columnData) {
        return AppFlowyGroupHeader(
          icon: const Icon(Icons.lightbulb_circle),
          title: SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController()
                ..text = columnData.headerData.groupName,
              onSubmitted: (val) {
                controller
                    .getGroupController(columnData.headerData.groupId)!
                    .updateGroupName(val);
              },
            ),
          ),
          addIcon: const Icon(Icons.add, size: 20),
          moreIcon: const Icon(Icons.more_horiz, size: 20),
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 12),
        );
      },
      footerBuilder: (context, columnData) {
        return AppFlowyGroupFooter(
          icon: const Icon(Icons.add, size: 20),
          title: const Text('New'),
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          onAddButtonClick: () {
            boardController.scrollToBottom(columnData.id);
          },
        );
      },
      boardScrollController: boardController,
      config: const AppFlowyBoardConfig(
        groupBackgroundColor: Colors.white12,
        stretchGroupHeight: false,
      ),
      groupConstraints: const BoxConstraints.tightFor(width: 300),
      controller: controller,
      cardBuilder: (context, group, groupItem) {
        final item = groupItem as TextItem;
        return AppFlowyGroupCard(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          key: ObjectKey(item),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Text(item.s),
            ),
          ),
        );
      },
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;

  TextItem(this.s);

  @override
  String get id => s;
}
