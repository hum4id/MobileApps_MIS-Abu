import 'package:equatable/equatable.dart';

enum SkillStatus {
  active('Active'),
  inactive('Inactive');

  const SkillStatus(this.label);
  final String label;
}

class Skill extends Equatable {
  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.usedBy,
  });

  final String id;
  final String name;
  final String category;
  final SkillStatus status;
  final int usedBy;

  @override
  List<Object?> get props => [id, name, category, status, usedBy];
}
