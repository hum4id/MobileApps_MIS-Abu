import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/approval.dart';

/// Data contoh dari mock web. Ganti dengan implementasi Dio saat API siap.
const _mockApprovals = <Approval>[
  Approval(
    id: '1',
    projectName: 'Peluncuran Produk Innovate Tech 2026',
    docType: ApprovalDocType.productionCost,
    applicationDate: '02 October 2026',
    totalCost: 800000,
    status: ApprovalStatus.pending,
  ),
  Approval(
    id: '2',
    projectName: 'Company Profile & Video Direksi',
    docType: ApprovalDocType.quotation,
    applicationDate: '16 August 2026',
    totalCost: 35000000,
    status: ApprovalStatus.pending,
  ),
  Approval(
    id: '3',
    projectName: 'Film Pendek Dokumenter Makromedia',
    docType: ApprovalDocType.invoice,
    applicationDate: '5 September 2026',
    totalCost: 70000000,
    status: ApprovalStatus.approved,
  ),
  Approval(
    id: '4',
    projectName: 'Campaign Media Sosial Ramadan & Idul Fitri',
    docType: ApprovalDocType.productionCost,
    applicationDate: '11 July 2026',
    totalCost: 10000000,
    status: ApprovalStatus.approved,
  ),
  Approval(
    id: '5',
    projectName: 'Annual Summit Livestream',
    docType: ApprovalDocType.quotation,
    applicationDate: '21 May 2026',
    totalCost: 22000000,
    status: ApprovalStatus.revise,
  ),
];

final approvalSearchProvider = StateProvider<String>((ref) => '');
final approvalStatusFilterProvider = StateProvider<ApprovalStatus?>((ref) => null);

final approvalListProvider = FutureProvider.autoDispose<List<Approval>>((ref) async {
  final query = ref.watch(approvalSearchProvider).trim().toLowerCase();
  final status = ref.watch(approvalStatusFilterProvider);
  await Future<void>.delayed(const Duration(milliseconds: 250));
  return _mockApprovals.where((a) {
    final matchesQuery = query.isEmpty ||
        a.projectName.toLowerCase().contains(query) ||
        a.docType.label.toLowerCase().contains(query);
    final matchesStatus = status == null || a.status == status;
    return matchesQuery && matchesStatus;
  }).toList();
});
