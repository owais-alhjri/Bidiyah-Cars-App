import 'package:car/admin_pages/adding_cars.dart';
import 'package:car/admin_pages/edit_cars.dart';
import 'package:car/pages/main_screen.dart';
import 'package:flutter/material.dart';

import '../navbar/navbar_page.dart';

class MainAdminPage extends StatefulWidget {
  const MainAdminPage({super.key});

  @override
  State<MainAdminPage> createState() => _MainAdminPageState();
}

class _MainAdminPageState extends State<MainAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN PAGE"),
      ),
      drawer: Navbar(),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home,size: 40,color: Colors.black,),
            title: Text("Main screen",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainScreen()));
            },
          ),
          SizedBox(height: 40,),
          ListTile(
            leading: Icon(Icons.directions_car,size: 40,color: Colors.black,),
            title: Text("Add new car",
    style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 30.0),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddingCars()));
            },
          ),
          SizedBox(height: 40,),
          ListTile(
            leading: Icon(Icons.edit,size: 40,color: Colors.black,),
            title: Text("Edit cars",
    style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 30.0),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditCars()));
            },
          ),
        ],

      ),
    );
  }
}
