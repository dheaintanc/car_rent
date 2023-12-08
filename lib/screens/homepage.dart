import 'package:car_rental/Cars/detail_car.dart';
import 'package:car_rental/api/api_source.dart';
import 'package:car_rental/constants/car_rental_impl.dart';
import 'package:car_rental/screens/Rental.dart';
import 'package:car_rental/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int selectedIndex = 0;
  late SharedPreferences _sharedPreferences;
  late String username;
  TextEditingController _searchController = TextEditingController();

  late Future<List<CarRents>> futureCarRents;

  @override
  void initState() {
    initial();
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
    futureCarRents = ApiSource().getCarRents();
  }

  initial() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    username = (_sharedPreferences.getString('username') ?? '');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/fe298101-6755-4dd2-8b2f-44c13b0b2ab3/aFz1fiL9UY.json',
              width: 50,
              height: 50,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sukalapak: Your Car Rental App',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            buildCarListPage(),
            CarRental(),
            MyProfile(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple,
        fixedColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: 'Rental',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget buildCarListPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome, Dhea',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 5.0,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/dhea.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
            ),
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder<List<CarRents>>(
          future: futureCarRents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              List<CarRents> carRents = snapshot.data ?? [];
              List<CarRents> filteredCarRents = carRents.where((car) {
                return car.make
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    car.model
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase());
              }).toList();

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: filteredCarRents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailCars(
                                carRents: filteredCarRents[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Lottie.network(
                                'https://lottie.host/b1e36bd9-5b26-4704-8e90-afbca7007e54/uFRnI15AYq.json',
                                width: 500,
                                height: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredCarRents[index].make,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      filteredCarRents[index].model,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${filteredCarRents[index].price}',
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  List<CarRents> filterCarList(List<CarRents>? carList, String searchText) {
    return carList
            ?.where((car) =>
                car.make.toLowerCase().contains(searchText.toLowerCase()) ||
                car.model.toLowerCase().contains(searchText.toLowerCase()))
            .toList() ??
        [];
  }
}
