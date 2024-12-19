import 'package:car/admin_pages/main_admin_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navbar/navbar_page.dart';

class UpdateCar extends StatefulWidget {
  final String carId;
  const UpdateCar({super.key, required this.carId});

  @override
  State<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends State<UpdateCar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  void initState() {
    super.initState();
    _loadCarsData(); // Load the car data when the page is initialized
  }

  void _loadCarsData() async {
    try {
      // Use the carId passed to this page to get the specific car document
      DocumentSnapshot carDoc = await _firestore.collection('cars').doc(widget.carId).get();

      if (carDoc.exists) {
        setState(() {
          name.text = carDoc['name'] ?? '';
          imageURL.text = carDoc['imageURL'] ?? '';
          price.text = carDoc['price']?.toString() ?? ''; // Ensure price is parsed correctly
          model.text = carDoc['model'] ?? '';
          description.text = carDoc['description'] ?? '';
        });
      } else {
        showSnackBar('Car not found');
      }
    } catch (e) {
      showSnackBar('Error loading car data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Car'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back))
        ],
      ),
      drawer: Navbar(),
      body: ListView(
        padding: EdgeInsets.all(50.0),

        children: [
          const Text("Update car details",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
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
                  showSnackBar('Name cannot be empty!');
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
                double carPrice = double.parse(price.text);

                await _firestore.collection('cars').doc(widget.carId).update({
                  'name': name.text,
                  'imageURL': imageURL.text,
                  'description': description.text,
                  'price': carPrice,
                  'model': model.text,
                });

                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Car updated successfully!',
                        textAlign: TextAlign.center,style: TextStyle(
                            fontSize: 20
                        ),),
                        backgroundColor: Colors.green,)
                  );
                });

                // Optionally navigate back or to another page
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MainAdminPage(),
                ));
              } catch (e) {
                setState(() {
                  showSnackBar('Error: $e');
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Color.fromRGBO(218, 215, 205,1),
              backgroundColor: Color.fromRGBO(52, 78, 65,1),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
           SizedBox(height: 10.0),
        ],

      ),

    );
  }
}
