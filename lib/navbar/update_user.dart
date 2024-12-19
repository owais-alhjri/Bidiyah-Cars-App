import 'package:car/navbar/navbar_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String _gender = '';
  String _message = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _fullName.text = userDoc['fullName'] ?? '';
            _age.text = userDoc['age'] ?? '';
            _gender = userDoc['gender'] ?? '';
            _phoneNumber.text = userDoc['phoneNumber'] ?? '';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
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

  void _updateProfile() async {
    try {
      User? user = _auth.currentUser;

      if (_fullName.text.isEmpty) {
        showSnackBar('Full name cannot be empty!');
        return;
      }
      if (_age.text.isEmpty) {
        showSnackBar('Age cannot be empty!');
        return;
      }
      if (user != null) {
        if (_phoneNumber.text.length != 8) {
          setState(() {
            showSnackBar('phone Number Should be 8 numbers!');
          });
          return;
        }

        // Update password
        if (_password.text.isNotEmpty &&
            _password.text == _confirmPassword.text) {
          await user.updatePassword(_password.text);
        }
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': _fullName.text,
          'age': _age.text,
          'gender': _gender,
          'phoneNumber': _phoneNumber.text,
        });
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Profile updated successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.green,
        ));
      } else {
        showSnackBar('No user is currently signed in.');
      }
    } catch (e) {
      showSnackBar('Error updating profile: $e');
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _age.dispose();
    _phoneNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Update User Profile",
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
          TextFormField(
            controller: _fullName,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_3_outlined),
              labelText: "Full Name",
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _age,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_month),
              labelText: "Age",
            ),
          ),
          RadioListTile(
              title: Text("Male"),
              value: "Male",
              groupValue: _gender,
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              }),
          RadioListTile(
              title: Text("Female"),
              value: "Female",
              groupValue: _gender,
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              }),
          TextFormField(
            controller: _phoneNumber,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone_iphone),
              labelText: "Phone Number",
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _password,
            keyboardType: TextInputType.text,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              labelText: "New Password",
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _confirmPassword,
            keyboardType: TextInputType.text,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              labelText: "Confirm New Password",
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              foregroundColor: Color.fromRGBO(218, 215, 205, 1),
              backgroundColor: Color.fromRGBO(52, 78, 65, 1),
            ),
            onPressed: _updateProfile,
            child: Text("Update Profile",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 5.0),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
