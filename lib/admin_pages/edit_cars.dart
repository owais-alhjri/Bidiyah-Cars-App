import 'package:car/cars/update_car.dart';
import 'package:car/navbar/navbar_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../cars/cars_firestore.dart';

class EditCars extends StatefulWidget {
  const EditCars({super.key});

  @override
  State<EditCars> createState() => _EditCarsState();
}

class _EditCarsState extends State<EditCars> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Cars"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      drawer: Navbar(),
      body: Column(
        children: [
          // Add the SearchBar
          SearchBar(
            leading: Icon(Icons.search, color: Colors.white),
            backgroundColor: WidgetStateProperty.all(
              Color.fromRGBO(0, 48, 48, 1),
            ),
            shadowColor: WidgetStateProperty.all(Colors.black87),
            elevation: WidgetStateProperty.all(10),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(40),bottomLeft: Radius.circular(40)),
              ),
            ),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
            hintText: '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tSearch for cars...',
            hintStyle: WidgetStateProperty.all(
              TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
            textStyle: WidgetStatePropertyAll(
                TextStyle(
                    color: Colors.white
                )
            ),
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase(); // Update the query
              });

            },

          ),
          // Car List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getCarsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No cars available",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // Filter cars based on search query
                List<DocumentSnapshot> carsList = snapshot.data!.docs.where((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  String carName = data['name'].toString().toLowerCase();
                  return carName.contains(searchQuery);
                }).toList();

                if (carsList.isEmpty) {
                  return Center(
                    child: Text(
                      "No cars match your search",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: carsList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = carsList[index];
                    String carId = document.id;
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    return Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: (index % 2 == 0)
                            ? Colors.grey.shade600
                            : Color.fromRGBO(83, 107, 99, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border.all(
                          width: 5,
                          color: Colors.white70,
                        ),
                      ),
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/${data['imageURL']}',
                            ),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image(
                              image: AssetImage('assets/image_not.jpg'),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            data['name'],
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(70, 30),
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.yellow,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdateCar(carId: carId),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16), // Added spacing between buttons
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(70, 30),
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    try {
                                      bool result = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.red[400],
                                          title: Text(
                                            'Delete Car',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this car?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (result) {
                                        FirebaseFirestore.instance
                                            .collection('cars')
                                            .doc(carId)
                                            .delete();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Car deleted successfully!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error deleting car: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
