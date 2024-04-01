import 'package:hooks_riverpod/hooks_riverpod.dart';

final ticketSummaryViewModelProvider = Provider((ref) => TicketSummaryViewModel(ref));

class TicketSummaryViewModel {
  final Ref ref;

  TicketSummaryViewModel(this.ref);
}
