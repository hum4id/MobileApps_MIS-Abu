import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/skill.dart';

/// Data contoh dari mock web. Ganti dengan implementasi Dio saat API siap.
const _mockSkills = <Skill>[
  Skill(id: '1', name: 'Director of Photography (DoP)', category: 'Camera', status: SkillStatus.active, usedBy: 2),
  Skill(id: '2', name: 'Camera Operator / Cameraman', category: 'Camera', status: SkillStatus.active, usedBy: 3),
  Skill(id: '3', name: 'Video Editor (Premiere / DaVinci)', category: 'Post-Production', status: SkillStatus.active, usedBy: 1),
  Skill(id: '4', name: 'Lighting Technician / Gaffer', category: 'Lighting', status: SkillStatus.inactive, usedBy: 0),
  Skill(id: '5', name: 'Audio Recordist / Sound Engineer', category: 'Audio', status: SkillStatus.active, usedBy: 1),
  Skill(id: '6', name: 'Drone Pilot (Certified)', category: 'Special Equipment', status: SkillStatus.active, usedBy: 1),
  Skill(id: '7', name: 'Leadership', category: 'Management', status: SkillStatus.active, usedBy: 2),
  Skill(id: '8', name: 'Project Management', category: 'Management', status: SkillStatus.active, usedBy: 2),
  Skill(id: '9', name: 'Strategic Planning', category: 'Management', status: SkillStatus.inactive, usedBy: 1),
  Skill(id: '10', name: 'Client Relations', category: 'Sales', status: SkillStatus.active, usedBy: 2),
];

final skillSearchProvider = StateProvider<String>((ref) => '');
final skillStatusFilterProvider = StateProvider<SkillStatus?>((ref) => null);

final skillListProvider = FutureProvider.autoDispose<List<Skill>>((ref) async {
  final query = ref.watch(skillSearchProvider).trim().toLowerCase();
  final status = ref.watch(skillStatusFilterProvider);
  await Future<void>.delayed(const Duration(milliseconds: 250));
  return _mockSkills.where((s) {
    final matchesQuery = query.isEmpty ||
        s.name.toLowerCase().contains(query) ||
        s.category.toLowerCase().contains(query);
    final matchesStatus = status == null || s.status == status;
    return matchesQuery && matchesStatus;
  }).toList();
});
