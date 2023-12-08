import 'package:car_rental/constants/car_rental_impl.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/carRentsDatabase.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class DetailCars extends StatefulWidget {
  const DetailCars({
    Key? key,
    required this.carRents,
  }) : super(key: key);

  final CarRents carRents;

  @override
  State<DetailCars> createState() => _DetailCarsState();
}

class _DetailCarsState extends State<DetailCars> {
  late Box<CarRentsData> carRentalBox;

  @override
  void initState() {
    super.initState();
    carRentalBox = Hive.box<CarRentsData>(CarName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Lottie.network(
                'https://lottie.host/fe298101-6755-4dd2-8b2f-44c13b0b2ab3/aFz1fiL9UY.json',
                width: 50,
                height: 50,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.carRents.make} ${widget.carRents.model}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Year: ${widget.carRents.year}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Color: ${widget.carRents.color}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mileage: ${widget.carRents.mileage} miles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Price: \$${widget.carRents.price}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    //button rent now
                    ElevatedButton(
                      onPressed: () {
                        carRentalBox = Hive.box<CarRentsData>(CarName);
                        carRentalBox.add(CarRentsData(
                          id: widget.carRents.id.toString(),
                          make: widget.carRents.make,
                          price: widget.carRents.price.toString(),
                          image: widget.carRents.image,
                          description: widget.carRents.model,
                          rating: widget.carRents.color,
                          location: widget.carRents.mileage.toString(),
                          type: widget.carRents.fuelType,
                          year: widget.carRents.year.toString(),
                          model: widget.carRents.transmission,
                          transmission: widget.carRents.engine,
                          fuel: widget.carRents.horsepower.toString(),
                          mileage: widget.carRents.mileage.toString(),
                          engine: widget.carRents.engine,
                          color: widget.carRents.color,
                          availability: widget.carRents.owners.toString(),
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Rent Success'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text('Rent Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
