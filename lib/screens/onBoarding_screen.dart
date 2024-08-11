import 'package:flutter/material.dart';
import '../widgets/customButton.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20), // Optional padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang Di\nAplikasi AutiVision',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Solusi Inovatif Untuk Deteksi Awal Autism\nSpectrum Disorder (ASD).',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 80),
              SvgPicture.asset('assets/svgs/boardingPict.svg', width: 300),
              SizedBox(height: 80),
              Text(
                'Aplikasi Terbaik untuk Deteksi ASD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/images/logoBiru.png',
                width: 150,
              ),
              SizedBox(height: 50),
              CustomButton(
                text: 'Lanjutkan',
                width: 350,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF034B6C),
                    Color(0xFF033B59),
                    Color(0xFF012139),
                  ],
                ),
                onPressed: () {
                  print('navigate to login');
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
