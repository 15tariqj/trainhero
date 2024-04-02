import 'package:trainhero/src/features/ticket_flow/domain/models/ticket.dart';

class QueryTicketResponse {
  final int success;
  final int claimRef;
  final Map<String, Ticket>? tickets;
  final String? message;
  final String? error;

  QueryTicketResponse({
    required this.success,
    required this.claimRef,
    this.tickets,
    this.message,
    this.error,
  });

  factory QueryTicketResponse.fromJson(Map<String, dynamic> json) {
    Map<String, Ticket>? tickets;
    if (json['tickets'] != null) {
      tickets = {};
      json['tickets'].forEach((key, value) {
        tickets![key] = Ticket.fromJson(value);
      });
    }

    return QueryTicketResponse(
      success: json['success'],
      claimRef: json['claimRef'],
      tickets: tickets,
      message: json['message'],
      error: json['error'],
    );
  }
}