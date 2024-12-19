import 'package:car/navbar/order_history.dart';
import 'package:car/navbar/update_user.dart';
import 'package:car/pages/login_page.dart';
import 'package:car/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../admin_pages/main_admin_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String age = "";
  final TextEditingController _email = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    _fetch();
  }

  void _fetch() async{
    try{
      User? user = _auth.currentUser;
      if(user != null){
        DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
        if(userDoc.exists){
          setState(() {
            _email.text = userDoc["email"] ??'';
            _fullName.text = userDoc['fullName'] ?? '';
            //_age.text = (userDoc['age'] ?? '').toString();
            //_phoneNumber.text = userDoc['phoneNumber'] ?? '';
            age = 'Age: ${_age.text}';
          });
        }
      }
    }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user data: $e')),
          );
    }
  }
  @override
  void dispose(){
    _fullName.dispose();
    _age.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(0, 48, 48, 1),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Welcome',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            accountEmail: Text(
              _fullName.text
                  ,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/image.jfif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white
            ),

          ),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white,),
            title: Text("Main Screen",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )),
            onTap: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
              _fetch();
            },
          ),
          ListTile(
            leading: Icon(Icons.person,color: Colors.white,),
            title: Text("Update profile",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )),
            onTap: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateUser()));
              _fetch();
            },
          ),
          ListTile(
            leading: Icon(Icons.history,color: Colors.white,),
            title: Text("Order History",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )),
            onTap: () async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderHistory()));
              _fetch();
            },
          ),
          ListTile(
            leading: Icon(Icons.do_not_disturb_alt,color: Colors.white,),
            title: Text("ADMIN ONLY",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            )),
            onTap: () async{
              if(_email.text == "admin@gmail.com"){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainAdminPage()));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ADMIN ONLY"),backgroundColor: Colors.red)
                );
              }
            },
          ),
          SizedBox(height: 60,),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.white,),
            title: Text("Logout",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),),
            onTap: ()async{
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User logged out',
                    textAlign: TextAlign.center,style: TextStyle(
                        fontSize: 20
                    ),),
                      backgroundColor: Colors.green)
              );
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginPage()));


            },
          )
        ],
      ),
    );
  }
}
