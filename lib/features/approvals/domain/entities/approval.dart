import 'package:equatable/equatable.dart';

enum ApprovalStatus {
  revise('Revise'),
  pending('Pending'),
  approved('Approved');

  const ApprovalStatus(this.label);
  final String label;
}

enum ApprovalDocType {
  productionCost('Production Cost'),
  quotation('Quotation'),
  invoice('Invoice');

  const ApprovalDocType(this.label);
  final String label;
}

class Approval extends Equatable {
  const Approval({
    required this.id,
    required this.projectName,
    required this.docType,
    required this.applicationDate,
    required this.totalCost,
    required this.status,
  });

  final String id;
  final String projectName;
  final ApprovalDocType docType;
  final String applicationDate;
  final int totalCost;
  final ApprovalStatus status;

  @override
  List<Object?> get props => [id, projectName, docType, applicationDate, totalCost, status];
}
