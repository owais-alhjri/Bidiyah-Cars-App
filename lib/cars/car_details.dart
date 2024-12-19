import 'package:car/cars/checkout.dart';
import 'package:flutter/material.dart';

import '../navbar/navbar_page.dart';

class CarDetails extends StatelessWidget {
  String name, model, description, imageURL,documentId;
  double price;
  CarDetails(
      {super.key,
      required this.imageURL,
      required this.name,
      required this.price,
      required this.model,
      required this.description,
      required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name,),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back))
        ],
      ),
      drawer: Navbar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 5,
                  color: Colors.white70,
                )),
            margin: EdgeInsets.all(18),
            child: Column(
              children: [
                Image(
                  image: AssetImage(
                    'assets/$imageURL',
                  ),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image(image: AssetImage(
                          'assets/image_not.jpg'),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100)),
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Column(

                children: [
                  ListTile(
                    leading: Icon(Icons.attach_money,color: Colors.white,),
                    title: Text(
                       '${price.toStringAsFixed(0)} OMR',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month,color: Colors.white),
                    title: Text(
                      model,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Description:\n${description.split('..').join('\n')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 40),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: ()  {
                      Navigator.push(context,MaterialPageRoute(
                          builder: (context){
                            return Checkout(price: price,documentId: documentId,);
                          }));

                    },
                    child: const Text(
                      "Checkout",
                      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
