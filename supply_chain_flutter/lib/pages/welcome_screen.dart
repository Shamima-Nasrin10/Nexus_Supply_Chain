import 'package:flutter/material.dart';
import 'package:path/path.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight / 1.6,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  Container(
                    width: screenWidth,
                    height: screenHeight / 1.6,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(70)),
                    ),
                    child: Center(
                      child: Image.asset(
                        "welcome_screen.png",
                        scale: 0.8,
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: screenWidth,
                  height: screenHeight / 2.66,
                  decoration: BoxDecoration(color: Colors.blueGrey),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: screenWidth,
                  height: screenHeight / 2.66,
                  padding: EdgeInsets.only(top: 40, bottom: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(70))),
                  child: Column(
                    children: [
                      Text("Master Your Supply Chain, Master Your Business",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            color: Colors.cyan
                          )
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text("Effortlessly streamline your supply chain operations with our powerful, user-friendly platform.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.withOpacity(0.6)
                        ),
                        ),
                      ),
                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
