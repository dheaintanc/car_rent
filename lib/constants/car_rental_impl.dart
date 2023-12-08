class CarRents {
  final int id;
  final String make;
  final String model;
  final int year;
  final String color;
  final int mileage;
  final int price;
  final String fuelType;
  final String transmission;
  final String engine;
  final int horsepower;
  final List<String> features;
  final int owners;
  final String image;

  CarRents({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.mileage,
    required this.price,
    required this.fuelType,
    required this.transmission,
    required this.engine,
    required this.horsepower,
    required this.features,
    required this.owners,
    required this.image,
  });

  CarRents.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        make = json['make'] as String,
        model = json['model'] as String,
        year = json['year'] as int,
        color = json['color'] as String,
        mileage = json['mileage'] as int,
        price = json['price'] as int,
        fuelType = json['fuelType'] as String,
        transmission = json['transmission'] as String,
        engine = json['engine'] as String,
        horsepower = json['horsepower'] as int,
        features =
            (json['features'] as List?)?.map((e) => e as String).toList() ?? [],
        owners = json['owners'] as int,
        image = json['image'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'make': make,
        'model': model,
        'year': year,
        'color': color,
        'mileage': mileage,
        'price': price,
        'fuelType': fuelType,
        'transmission': transmission,
        'engine': engine,
        'horsepower': horsepower,
        'features': features,
        'owners': owners,
        'image': image,
      };
}
