class GpsMeasureEntity {
  final int x;
  final int y;
  final int distance;
  final int speed;
  final DateTime date;

  const GpsMeasureEntity({
    required this.x,
    required this.y,
    required this.distance,
    required this.speed,
    required this.date,
  });
}