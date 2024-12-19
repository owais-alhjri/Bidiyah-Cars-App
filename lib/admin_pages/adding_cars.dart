import 'package:car/admin_pages/main_admin_page.dart';
import 'package:car/cars/cars_firestore.dart';
import 'package:flutter/material.dart';

import '../navbar/navbar_page.dart';

class AddingCars extends StatefulWidget {
  const AddingCars({super.key});

  @override
  State<AddingCars> createState() => _AddingCarsState();
}

class _AddingCarsState extends State<AddingCars> {
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController name = TextEditingController();
  TextEditingController imageURL = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController model = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    imageURL.dispose();
    description.dispose();
    price.dispose();
    model.dispose();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Cars',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back))
        ],
      ),
      drawer: Navbar(),
      body: ListView(
        padding: EdgeInsets.all(50.0),
        children: [
          const Text("Add the car to database",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: name,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.directions_car),
              labelText: "Car Name",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: imageURL,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.image),
              labelText: "image path",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.price_change_rounded),
              labelText: "Car Price",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: model,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_month),
              labelText: "Car Model",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            maxLines: 5,
            controller: description,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
              labelText: "Description",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () async {
              if (name.text.isEmpty) {
                setState(() {
                  showSnackBar('name cannot be empty!');
                });
                return;
              }
              if (imageURL.text.isEmpty) {
                setState(() {
                  showSnackBar('Image URL cannot be empty!');
                });
                return;
              }
              if (description.text.isEmpty) {
                setState(() {
                  showSnackBar('Description cannot be empty!');
                });
                return;
              }
              if (price.text.isEmpty) {
                setState(() {
                  showSnackBar('Price cannot be empty!');
                });
                return;
              }

              if (model.text.isEmpty) {
                setState(() {
                  showSnackBar('Model cannot be empty!');
                });
                return;
              }
              try {
                double carPrice =
                    double.parse(price.text); // Parsing price as double
                await _firestoreService.addCar(
                  name.text,
                  imageURL.text,
                  description.text,
                  carPrice,
                  model.text,
                );
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Car added successfully!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainAdminPage()));
                });
              } catch (e) {
                setState(() {
                  showSnackBar(e.toString());
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Color.fromRGBO(218, 215, 205, 1),
              backgroundColor: Color.fromRGBO(52, 78, 65, 1),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
