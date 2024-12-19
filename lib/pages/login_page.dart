import 'package:car/admin_pages/main_admin_page.dart';
import 'package:car/pages/main_screen.dart';
import 'package:car/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final _auth = FirebaseAuth.instance;
  final  TextEditingController _email = TextEditingController();
  final  TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(50),
        children: [

          Image(image: AssetImage('assets/logo2.png')),
          const Text(
          "Welcome Back",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
          const Text("Log in to your account\n"
          "using email and password",
          style: TextStyle( fontSize: 18.0),
          ),
          const SizedBox(height: 30.0),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
              ),
              prefixIcon: Icon(Icons.email_outlined),
              labelText: "Email",
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _password,
            keyboardType: TextInputType.text,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
              labelText: "Password",
            ),
          ),
          const SizedBox(height: 10.0),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              foregroundColor: Color.fromRGBO(218, 215, 205,1),
              backgroundColor: Color.fromRGBO(52, 78, 65,1),
            ),
            onPressed: () async {
              setState(() {
                if (_email.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Blank Email is not allowed!',
                        textAlign: TextAlign.center,style: TextStyle(
                            fontSize: 20
                        ),),
                          backgroundColor: Colors.red)
                  );
                  return;
                }
                if (_password.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Blank Password is not allowed!',
                        textAlign: TextAlign.center,style: TextStyle(
                            fontSize: 20
                        ),),
                          backgroundColor: Colors.red)
                  );
                  return;
                }
              });

              try {
                // Attempt to log in with Firebase
                final userCredential = await _auth.signInWithEmailAndPassword(
                  email: _email.text.trim(),
                  password: _password.text.trim(),

                );

                if(userCredential.user?.email == "admin@gmail.com" ){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  MainAdminPage()),);
                }else{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  MainScreen()),
                  );}
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Log in successfully',
                      textAlign: TextAlign.center,style: TextStyle(
                        fontSize: 20
                      ),),
                      backgroundColor: Colors.green,)
                );
              } catch (e) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid Email or Password',
                        textAlign: TextAlign.center,style: TextStyle(
                            fontSize: 20
                        ),),
                      backgroundColor: Colors.red,)
                  );

                });
              }

            },
            child: const Text(
              "Log In",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              const Text("First time here?"),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                },
                child: Text(
                  "Sign up",
                  style: TextStyle(color: Colors.blue[900]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

        ],
      ),
    );
  }
}
