class Task {
  final String name;
  final int indicatorToMoId;
  final int parentId;
  final int order;

  Task({
    required this.name,
    required this.indicatorToMoId,
    required this.parentId,
    required this.order,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'] as String,
      indicatorToMoId: json['indicator_to_mo_id'] as int,
      parentId: json['parent_id'] as int,
      order: json['order'] as int,
    );
  }

  Task copyWith({
    String? name,
    int? indicatorToMoId,
    int? parentId,
    int? order,
  }) {
    return Task(
      name: name ?? this.name,
      indicatorToMoId: indicatorToMoId ?? this.indicatorToMoId,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
    );
  }
}
