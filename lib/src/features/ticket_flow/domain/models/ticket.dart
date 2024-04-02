class Ticket {
  final String arrTime;
  final String depTime;
  final String destCrs;
  final int flexible;
  final String origCrs;
  final String price;
  final int returnTkt;
  final String ticketNumber;
  final String validFrom;
  final String validTo;
  final String ticketType;

  Ticket({
    required this.arrTime,
    required this.depTime,
    required this.destCrs,
    required this.flexible,
    required this.origCrs,
    required this.price,
    required this.returnTkt,
    required this.ticketNumber,
    required this.validFrom,
    required this.validTo,
    required this.ticketType,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      arrTime: json['arrTime'],
      depTime: json['depTime'],
      destCrs: json['destCrs'],
      flexible: json['flexible'],
      origCrs: json['origCrs'],
      price: json['price'],
      returnTkt: json['returnTkt'],
      ticketNumber: json['ticketNumber'],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
      ticketType: json['ticket_type'],
    );
  }
}