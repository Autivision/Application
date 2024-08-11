import 'package:autivision/widgets/customButton.dart';
import 'package:flutter/material.dart';

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  // Dummy URL for demonstration, replace with your actual Firebase Storage URL
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/autivision-c1daf.appspot.com/o/example_image.jpg?alt=media';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay for demonstration
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Stack(
            children: [
              Container(
                height: 800,
                width: double.infinity,
              ),
              Header(),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 54),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 3, color: Color(0xFF012139)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF034B6C),
                                  ),
                                ),
                              )
                            : Image.network(
                                imageUrl, 
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ),
                      ),
                      SizedBox(height: 26),
                      Container(
                        width: 285,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instruksi Gambar:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '1. Pastikan gambar yang diunggah memiliki pencahayaan yang cukup.\n'
                              '2. Gambar harus fokus dan tidak blur.\n'
                              '3. Hindari latar belakang yang berantakan.\n'
                              '4. Pastikan objek dalam gambar terlihat jelas.\n'
                              '5. Resolusi gambar yang baik akan membantu hasil klasifikasi yang lebih akurat.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: CustomButton(
                                text: "Saya Mengerti",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                width: 225,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF034B6C),
                                    Color(0xFF033B59),
                                    Color(0xFF012139),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 80),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF02243D),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Image.asset('assets/images/logoPutih.png', width: 120),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Deteksi ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' Dini ASD Untuk Pengobatan Terbaik',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
