import 'package:trainhero/src/features/ticket_flow/domain/models/departure.dart';

class FindDeparturesResponse {
  final List<Departure> departures;

  FindDeparturesResponse({
    required this.departures,
  });

  factory FindDeparturesResponse.fromJson(Map<String, dynamic> json) {
    List<Departure> departures = [];
    if (json['message'] != null) {
      return FindDeparturesResponse(departures: []);
    }
    Map<String, dynamic> departureJsons = json['closestDepartures'];
    for (Map<String, dynamic> departureJson in departureJsons.values) {
      departures.add(Departure.fromJson(departureJson));
    }
    return FindDeparturesResponse(departures: departures);
  }
}
