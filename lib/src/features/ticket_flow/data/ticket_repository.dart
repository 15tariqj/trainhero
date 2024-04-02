import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trainhero/src/features/ticket_flow/domain/models/find_departures_response.dart';
import 'package:trainhero/src/features/ticket_flow/domain/models/query_ticket_response.dart';

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return MockTicketRepository();
});

final ticketResponseProvider = FutureProvider((ref) async {
  final repository = ref.watch(ticketRepositoryProvider);
  return repository.queryTicket();
});

final ticketResponseStateProvider = StateProvider<QueryTicketResponse?>((ref) => null);
final departuresResponseStateProvider = StateProvider<FindDeparturesResponse?>((ref) => null);

abstract class TicketRepository {
  Future<QueryTicketResponse> queryTicket();
  Future<FindDeparturesResponse> findDepartures();
}

class MockTicketRepository implements TicketRepository {
  @override
  Future<QueryTicketResponse> queryTicket() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(
      QueryTicketResponse.fromJson(
        {
          "success": 1,
          "claimRef": 12345678910,
          "tickets": {
            "ticket1": {
              "arrTime": "1650",
              "depTime": "1433",
              "destCrs": "EUS",
              "flexible": 1,
              "origCrs": "CRE",
              "price": "2350",
              "returnTkt": 1,
              "ticketNumber": "AOCYSQ5G2GJ",
              "validFrom": "20220529",
              "validTo": "20220529",
              "ticket_type": "to_be_added_later"
            },
            "ticket2": {
              "arrTime": "1902",
              "depTime": "1646",
              "destCrs": "CRE",
              "flexible": 1,
              "origCrs": "EUS",
              "price": "2350",
              "returnTkt": 1,
              "ticketNumber": "AOCYSQ5G2GJ",
              "validFrom": "20220529",
              "validTo": "20220628",
              "ticket_type": "to_be_added_later"
            }
          }
        },
      ),
    );
  }

  @override
  Future<FindDeparturesResponse> findDepartures() async {
    await Future.delayed(const Duration(seconds: 2));
    return FindDeparturesResponse.fromJson({
      "closestDepartures": {
        "1": {"arrTime": "0944", "depTime": "0837", "toc": "LM"},
        "2": {"arrTime": "0958", "depTime": "0901", "toc": "LM"},
        "3": {"arrTime": "1010", "depTime": "0906", "toc": "LM"},
        "4": {"arrTime": "1026", "depTime": "0938", "toc": "VT"},
        "5": {"arrTime": "1044", "depTime": "0942", "toc": "LM"}
      },
      "success": 1
    });
  }
}

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl();

  @override
  Future<QueryTicketResponse> queryTicket() async {
    // TODO: implement queryTicket
    throw UnimplementedError();
  }

  @override
  Future<FindDeparturesResponse> findDepartures() {
    // TODO: implement findDepartures
    throw UnimplementedError();
  }
}
