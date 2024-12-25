import 'package:flutter/material.dart';
import 'LoginPage.dart';

//Backgrond
class StartNow extends StatelessWidget {
  const StartNow({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sign_up.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //Text
        Positioned(
          top: screenHeight * 0.35,
          right: screenWidth * 0.2,
          child: const Text(
            'Furniture',
            style: TextStyle(
              fontSize: 37,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
        ),
        const Positioned(
          top: 375,
          right: 20,
          child: Text(
            'With you anytime',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2321),
            ),
          ),
        ),
        Positioned(
          bottom: 120, // Adjusted position for Start Now button
          left: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(187, 187, 187, 0.75),
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Start Now',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white, width: 2),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
