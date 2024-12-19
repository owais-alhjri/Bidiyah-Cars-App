import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../navbar/navbar_page.dart';

class Checkout extends StatefulWidget {
  final double price;
  final documentId;

  const Checkout({super.key, required this.price, this.documentId});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double delivery = 0;
  bool termsAccepted = false;
  bool loc = false;
  String deliveryMethod = 'pickup';
  TextEditingController location = TextEditingController();

  double getPriceAfterDelivery() {
    return widget.price + delivery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
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
      body: ListView(
        padding: EdgeInsets.all(40),
        children: [
          Text('Delivery Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
          RadioListTile<double>(
            title: Text('Standard Delivery (5 OMR)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            value: 5,
            groupValue: delivery,
            onChanged: (double? value) {
              setState(() {
                delivery = value ?? 0;
                deliveryMethod = 'standard';
                location.clear(); // Clear location for standard
              });
            },
          ),
          RadioListTile<double>(
            title: Text('Express Delivery (10 OMR)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            value: 10,
            groupValue: delivery,
            onChanged: (double? value) {
              setState(() {
                delivery = value ?? 0;
                deliveryMethod = 'express';
                location.clear(); // Clear location for express
              });
            },
          ),
          RadioListTile<double>(
            title: Text('Pick up from the Shop',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            value: 0,
            groupValue: delivery,
            onChanged: (double? value) {
              setState(() {
                delivery = value ?? 0;
                deliveryMethod = 'pickup';
                location.text = 'Pick up from Bidiyah industrial area'; // Set default location
              });
            },
          ),
          SizedBox(height: 10),
          if (deliveryMethod == 'standard' || deliveryMethod == 'express')
            Center(
              child: TextFormField(
                controller: location,
                onTap: (){
                  setState(() {
                    if(location == ''){
                      loc = false;
                    }
                    else{
                      loc = true;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter your Location',
                  hintText: 'Enter your location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          if (deliveryMethod == 'pickup')
            Center(
              child: Text(
                'Shop location: \nBidiyah industrial area',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 60),
          Text(
            'Total Price: ${getPriceAfterDelivery().toStringAsFixed(0)} OMR',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Checkbox(
                value: termsAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    termsAccepted = value ?? false;
                  });
                },
              ),
              Text('I agree to the terms and conditions'),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              foregroundColor: Color.fromRGBO(218, 215, 205, 1),
              backgroundColor: Color.fromRGBO(52, 78, 65, 1),
            ),
            onPressed: () async {
              String? userId = FirebaseAuth.instance.currentUser?.uid;
              if (termsAccepted && loc) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Order confirmed',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                await _firestore.collection('orders').add({
                  'orderID': widget.documentId.toString(),
                  'order Time': DateTime.now(),
                  'userId': userId.toString(),
                  'pricePaid': getPriceAfterDelivery(),
                  'deliveryLocation': location.text,
                  'deliveryMethod': deliveryMethod,
                });
                Navigator.pop(context);
              } else {
                if(!termsAccepted){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'You have to agree to the terms and conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
                if(!loc){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'You have to enter a location for delivery',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              }
            },
            child: Text(
              'Confirm Order',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
