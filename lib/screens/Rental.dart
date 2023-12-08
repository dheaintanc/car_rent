import 'dart:async';
import 'dart:convert';

import 'package:car_rental/main.dart';
import 'package:car_rental/model/carRentsDatabase.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

enum Currency { USD, THB, AED, EUR, IDR }

enum TimeZone { WIB, WITA, WIT, SouthKr, London }

class CarRental extends StatefulWidget {
  const CarRental({Key? key}) : super(key: key);

  @override
  State<CarRental> createState() => _CarRentalState();
}

class _CarRentalState extends State<CarRental> {
  late Box<CarRentsData> carRentalBox;
  Currency selectedCurrency = Currency.USD;
  late Timer timer;
  TimeZone selectedTimeZone = TimeZone.WIB;
  String? formattedTime;

  @override
  void initState() {
    super.initState();
    carRentalBox = Hive.box<CarRentsData>(CarName);
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      getTime();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Rental',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTimeWidgets(),
            SizedBox(height: 20),
            Text(
              'Car Rental List :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: carRentalBox.length,
                itemBuilder: (context, index) {
                  final carRents = carRentalBox.getAt(index);
                  return Dismissible(
                    key: Key(carRents!.id.toString()),
                    onDismissed: (direction) {
                      carRentalBox.deleteAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${carRents.make} ${carRents.model} has been deleted',
                          ),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ListTile(
                          leading: Image.network(
                            'https://img.freepik.com/free-vector/car-driving-concept-illustration_114360-8091.jpg?w=900&t=st=1700843866~exp=1700844466~hmac=c32ce3092b9be49a67c6dc09faca69895733db9858a1e021d0e67d359516582a',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                          title: Text(
                            '${carRents.make} ${carRents.model}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${carRents.year} | ${carRents.color} | ${carRents.mileage} miles',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            '${formatPrice(
                              carRents.price.characters.length > 0
                                  ? double.parse(carRents.price)
                                  : 0 as double,
                            )}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildFormattedTime(),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Currency',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCurrencyDropdown(),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time Zone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildTimezoneDropdown(),
          ],
        ),
      ],
    );
  }

  Widget _buildFormattedTime() {
    return Text(
      formattedTime ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButton<Currency>(
      value: selectedCurrency,
      onChanged: (Currency? newValue) {
        setState(() {
          selectedCurrency = newValue!;
        });
      },
      items: Currency.values.map((Currency currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Text(getCurrencySymbol(currency)),
        );
      }).toList(),
    );
  }

  Widget _buildTimezoneDropdown() {
    return DropdownButton<TimeZone>(
      value: selectedTimeZone,
      onChanged: (TimeZone? newValue) {
        setState(() {
          selectedTimeZone = newValue!;
        });
      },
      items: TimeZone.values.map((TimeZone timeZone) {
        return DropdownMenuItem<TimeZone>(
          value: timeZone,
          child: Text(
            "Convert To ${timeZone.toString().split('.').last}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  void getTime() async {
    try {
      Response response = await get(
          Uri.parse("https://worldtimeapi.org/api/timezone/Asia/Jakarta"));
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      formattedTime = _getFormattedTime(now, selectedTimeZone);
      setState(() {});
    } catch (e) {
      print('Error fetching time: $e');
    }
  }

  String _getFormattedTime(DateTime time, TimeZone timeZone) {
    switch (timeZone) {
      case TimeZone.WIB:
        return '${time.hour}:${time.minute}:${time.second} WIB';
      case TimeZone.WITA:
        return '${time.hour + 1}:${time.minute}:${time.second} WITA';
      case TimeZone.WIT:
        return '${time.hour + 2}:${time.minute}:${time.second} WIT';
      case TimeZone.SouthKr:
        return '${time.hour + 2}:${time.minute}:${time.second} Korea Selatan';
      case TimeZone.London:
        return '${time.hour + 7}:${time.minute}:${time.second} London';
      default:
        return '';
    }
  }

  String formatPrice(double price) {
    switch (selectedCurrency) {
      case Currency.USD:
        return '\$ ${price.toStringAsFixed(2)}';
      case Currency.THB:
        return '฿ ${(price * 32).toStringAsFixed(2)}';
      case Currency.AED:
        return 'AED ${(price * 4).toStringAsFixed(0)}';
      case Currency.EUR:
        return '€ ${(price * 0.85).toStringAsFixed(2)}';
      case Currency.IDR:
        return 'Rp ${(price * 15532.6).toStringAsFixed(2)}';
    }
  }

  String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.THB:
        return '฿';
      case Currency.AED:
        return 'AED';
      case Currency.EUR:
        return '€';
      case Currency.IDR:
        return 'Rp';
    }
  }
}
