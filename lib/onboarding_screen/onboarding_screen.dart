import 'package:cropnurture/screens/Home_screen.dart';
import 'package:cropnurture/screens/login_signup_screen.dart';
import 'package:cropnurture/screens/navbar.dart';
import 'package:flutter/material.dart';
import 'onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: _currentPage == index ? Color(0xFF0F255A) : Color(0xFFBCC1CD),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    // Background image for first screen
                    // if (i == 0)
                      Positioned.fill(
                        child: Image.asset(
                          contents[i].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    // else
                    //   Positioned(
                    //     bottom: height * 0.2, // Adjust this to position the image above the button
                    //     left: 0,
                    //     right: 0,
                    //     child: Image.asset(
                    //       contents[i].image,
                    //       fit: BoxFit.contain,
                    //       alignment: Alignment.bottomCenter,
                    //       height: height * 0.4,  // Adjust the height as needed
                    //     ),
                    //   ),
                    // Overlay text and buttons
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontFamily: "Painted Paradise",
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.12, // Responsive font size
                                color:  Color(0xFF4CAF50),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            if (contents[i].title == "Features")
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  // Generate the points list and spread it here
                                  for (var index = 0; index < contents[i].points!.length; index++)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.08,
                                            height: width * 0.08,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF4CAF50),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.04,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width * 0.04),
                                          Expanded(
                                            child: Text(
                                              contents[i].points![index],
                                              style: TextStyle(
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.04,
                                                color: Colors.brown,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Add padding or a SizedBox for spacing
                                  SizedBox(height: height * 0.05), // Adjust the height as needed for spacing
                                ],
                              )
                            else
                              Text(
                                contents[i].desc,
                                style: TextStyle(
                                  fontFamily: "Urbanist",
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.05,
                                  color: Color(0xFF4CAF50),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            SizedBox(height: height * 0.2),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: height * 0.05,
              left: width * 0.05,
              right: width * 0.05,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage + 1 == contents.length) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      _currentPage + 1 == contents.length ? "START" : "NEXT",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Changed to rectangular
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, horizontal: width * 0.25), // Adjust padding
                      textStyle: TextStyle(
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  if(_currentPage < 2 )// Spacing between button and skip text
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(contents.length - 1);
                    },
                    child: const Text(
                      "SKIP",
                      style: TextStyle(
                        color: Color(0xFF0F255A),
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
