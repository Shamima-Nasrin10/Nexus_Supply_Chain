import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/pages/homepage.dart';
import 'package:supply_chain_flutter/pages/registrationpage.dart';
import 'package:supply_chain_flutter/pages/welcome_screen.dart';

class Login extends StatelessWidget {
  final TextEditingController email = TextEditingController()..text='test@gmail.com';
  final TextEditingController password = TextEditingController()..text='test1234';
  final storage = FlutterSecureStorage();

  Future<void> loginUser(BuildContext context) async {
    final apiUrl = Uri.parse('http://localhost:8080/api/login');
    final response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.text, 'password': password.text}),
    );

    print(response);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String sub = payload['sub'];
      String role = payload['role'];

      await storage.write(key: 'token', value: token);
      await storage.write(key: 'sub', value: sub);
      await storage.write(key: 'role', value: role);

      print('Login successful. Sub: $sub, Role: $role');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } else {
      print('Login failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black12, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,  // White space above
                ),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),  // Slightly transparent
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(200),  // Perfectly round upper-left corner
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30),

                          // Email TextField
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blueAccent),
                              ),
                              prefixIcon: Icon(Icons.email, color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20),

                          // Password TextField
                          TextField(
                            controller: password,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blueAccent),
                              ),
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                            ),
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20),

                          // Login Button
                          ElevatedButton(
                            onPressed: () {
                              String em = email.text;
                              String pass = password.text;
                              print('Email: $em, Password: $pass');
                              loginUser(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Button color
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Registration Text Button
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationPage()),
                              );
                            },
                            child: Text(
                              'Not a member? Register here',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
