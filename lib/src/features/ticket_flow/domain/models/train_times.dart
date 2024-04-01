class TrainTime {
  final String arrivalTime;
  final String departureTime;
  bool isPressed = false;

  TrainTime({
    required this.arrivalTime,
    required this.departureTime,
    this.isPressed = false,
  });
}
