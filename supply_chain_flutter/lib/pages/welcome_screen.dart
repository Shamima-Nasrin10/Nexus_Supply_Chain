import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/pages/homepage.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight / 1.6,
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/welcome_screen.png",
                  scale: 0.8,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              height: screenHeight / 2.66,
              decoration: BoxDecoration(color: Colors.blueGrey),
            ),
          ),

          // Bottom Section Content (Scrollable content inside SingleChildScrollView)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              height: screenHeight / 2.66,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 40, bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Master Your Supply Chain, Master Your Business",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Text("Get Started"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
