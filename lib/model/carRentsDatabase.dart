import 'package:hive/hive.dart';

part 'carRentsDatabase.g.dart';

@HiveType(typeId: 0)
class CarRentsData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String make;

  @HiveField(2)
  String price;

  @HiveField(3)
  String image;

  @HiveField(4)
  String description;

  @HiveField(5)
  String rating;

  @HiveField(6)
  String location;

  @HiveField(7)
  String type;

  @HiveField(8)
  String year;

  @HiveField(9)
  String model;

  @HiveField(10)
  String transmission;

  @HiveField(11)
  String fuel;

  @HiveField(12)
  String mileage;

  @HiveField(13)
  String engine;

  @HiveField(14)
  String color;

  @HiveField(15)
  String availability;

  CarRentsData(
      {required this.id,
      required this.make,
      required this.price,
      required this.image,
      required this.description,
      required this.rating,
      required this.location,
      required this.type,
      required this.year,
      required this.model,
      required this.transmission,
      required this.fuel,
      required this.mileage,
      required this.engine,
      required this.color,
      required this.availability});
}
