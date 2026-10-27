import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_manpower_repository.dart';
import '../../domain/entities/manpower.dart';
import '../../domain/repositories/manpower_repository.dart';

final manpowerRepositoryProvider =
    Provider<ManpowerRepository>((ref) => MockManpowerRepository());

final manpowerSearchProvider = StateProvider<String>((ref) => '');

/// null = semua status.
final manpowerStatusFilterProvider = StateProvider<EmploymentStatus?>((ref) => null);

final manpowerListProvider = FutureProvider.autoDispose<List<Manpower>>((ref) {
  final query = ref.watch(manpowerSearchProvider);
  final status = ref.watch(manpowerStatusFilterProvider);
  return ref.watch(manpowerRepositoryProvider).fetchManpower(query: query, status: status);
});
