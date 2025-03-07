class StatusHelper {
  static String getValue(Status status) {
    switch (status) {
      case Status.pending:
        return 'Pending';
      case Status.approved:
        return 'Approved';
      case Status.rejected:
        return 'Rejected';
    }
  }
}

enum Status {
  pending,
  approved,
  rejected,
}
