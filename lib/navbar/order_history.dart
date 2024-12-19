import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navbar_page.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? userID = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where("userId", isEqualTo: userID?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error encountered!",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Orders!',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // Access the fields for order details
                var docId = snapshot.data!.docs[index]['orderID'];
                var delivery = snapshot.data!.docs[index]['deliveryLocation'];
                double pricePaid = snapshot.data!.docs[index]['pricePaid'] ?? 0;
                DateTime time = (snapshot.data!.docs[index]['order Time'] as Timestamp).toDate();

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('cars').doc(docId).get(),
                  builder: (context, carSnapshot) {
                    if (carSnapshot.connectionState == ConnectionState.waiting) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: ListTile(
                          title: CupertinoActivityIndicator(),
                        ),
                      );
                    }
                    if (!carSnapshot.hasData || carSnapshot.hasError) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: ListTile(
                          title: Text('Error loading car details'),
                        ),
                      );
                    }

                    var carData = carSnapshot.data!;
                    String carName = carData['name'] ?? 'Unknown';
                    String carImage = carData['imageURL'] ?? '';

                    return Card(
                      color: (index % 2 == 0)? Colors.grey.shade600:Color.fromRGBO(83, 107, 99,1),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ListTile(
                        title: Text(
                          'Delivery Location: $delivery',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price paid: ${pricePaid.toStringAsFixed(0)} OMR',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: (index % 2 == 0)? Colors.grey.shade600:Color.fromRGBO(83, 107, 99,1),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  )
                                ],
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  )

                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/$carImage',
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ]
                              ),
                            ),
                            SizedBox(height: 5,),


                            Text(
                              'Car Name: $carName',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Order Time: ${time.toLocal().toString()}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: Text('Something went wrong...'),
          );
        },
      ),
    );
  }
}
