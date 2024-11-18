import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/pages/homepage.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              // Top Section
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
                      "welcome_screen.png",
                      scale: 0.8,
                    ),
                  ),
                ),
              ),

              // Bottom Section Background
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: screenWidth,
                  height: screenHeight / 2.66,
                  decoration: BoxDecoration(color: Colors.blueGrey),
                ),
              ),

              // Bottom Section Content
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Title
                        Text(
                          "Master Your Supply Chain, Master Your Business",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.cyan,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),

                        // Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Effortlessly streamline your supply chain operations with our powerful, user-friendly platform.",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Button
                        Spacer(),
                        Material(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=> HomePage(),
                                  ));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 50,
                              ),
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
