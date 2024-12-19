import 'package:car/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String gender = '';

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    age.dispose();
    password.dispose();
    confirmPassword.dispose();
    phoneNumber.dispose();
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
      body: ListView(
        padding: EdgeInsets.all(50.0),
        children: [
          const Text(
            "Create New Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: fullName,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_3_outlined),
              labelText: "Full Name",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: age,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_month),
              labelText: "Age",
            ),
          ),
          RadioListTile(
            title: Text("Male"),
            value: "Male",
            groupValue: gender,
            onChanged: (newValue) {
              setState(() {
                gender = newValue!;
              });
            },
          ),
          RadioListTile(
            title: Text("Female"),
            value: "Female",
            groupValue: gender,
            onChanged: (newValue) {
              setState(() {
                gender = newValue!;
              });
            },
          ),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
              labelText: "Email",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: phoneNumber,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone_iphone),
              labelText: "Phone Number",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: password,
            keyboardType: TextInputType.text,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
              labelText: "Password",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: confirmPassword,
            keyboardType: TextInputType.text,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
              labelText: "Confirm Password",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              foregroundColor: Color.fromRGBO(218, 215, 205,1),
              backgroundColor: Color.fromRGBO(52, 78, 65,1),
            ),
            onPressed: () async {
              if (fullName.text.isEmpty) {
                showSnackBar('Full name cannot be empty!');
                return;
              }
              if (age.text.isEmpty) {
                showSnackBar('Age cannot be empty!');
                return;
              }
              if (gender.isEmpty) {
                showSnackBar('Gender cannot be empty!');
                return;
              }
              if (email.text.isEmpty) {
                showSnackBar('Email cannot be empty!');
                return;
              }
              if (phoneNumber.text.isEmpty) {
                showSnackBar('Phone number cannot be empty!');
                return;
              }
              if (phoneNumber.text.length != 8) {
                showSnackBar('Phone number should be 8 digits!');
                return;
              }
              if (password.text.isEmpty) {
                showSnackBar('Password cannot be empty!');
                return;
              }
              if (password.text != confirmPassword.text) {
                showSnackBar("Passwords do not match!");
                return;
              }

              try {
                UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
                  email: email.text,
                  password: password.text,
                );

                if (userCredential.user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'fullName': fullName.text.trim(),
                    'age': age.text.trim(),
                    'gender': gender,
                    'email': email.text.trim(),
                    'phoneNumber': phoneNumber.text.trim(),
                    'createdAt': DateTime.now(),
                  }).catchError((error) {
                    print("Failed to write user data: $error");
                  });
                }

                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registered successfully',
                      textAlign: TextAlign.center,style: TextStyle(
                          fontSize: 20
                      ),),
                      backgroundColor: Colors.green,)
                );
              } catch (e) {
                showSnackBar(e.toString());
              }
            },
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                },
                child: Text(
                  "Log In",
                  style: TextStyle(color: Colors.blue[900]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
