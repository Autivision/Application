import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/customButton.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/logoBiru.png',
                    width: 150,
                  ),
                ),
                SizedBox(height: 50),
                SignupForm(authProvider: authProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final AuthProvider authProvider;

  SignupForm({required this.authProvider});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _profileImage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _profileImage = File(croppedFile.path);
        });
      }
    }
  }

  Future<String?> _uploadProfileImage(File file) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload profile image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Daftar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            SignupImagePicker(
              profileImage: _profileImage,
              pickImage: _pickImage,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nama Pengguna',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama pengguna tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Masukkan email yang valid';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText1,
              decoration: InputDecoration(
                labelText: 'Kata Sandi',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText1 = !_obscureText1;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Kata sandi harus memiliki minimal 6 karakter';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureText2,
              decoration: InputDecoration(
                labelText: 'Ulangi Kata Sandi',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText2 = !_obscureText2;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi kata sandi tidak boleh kosong';
                }
                if (value != _passwordController.text) {
                  return 'Kata sandi tidak cocok';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Dengan mendaftar akun, anda menyetujui syarat dan ketentuan kami.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Daftar',
              width: double.infinity,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF034B6C),
                  Color(0xFF033B59),
                  Color(0xFF012139),
                ],
              ),
              isLoading: _isLoading,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });

                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String username = _usernameController.text;

                  String? profileImageUrl;
                  if (_profileImage != null) {
                    profileImageUrl = await _uploadProfileImage(_profileImage!);
                  }

                  await widget.authProvider.signUpWithEmail(
                      email, password, username, profileImageUrl);

                  setState(() {
                    _isLoading = false;
                  });

                  if (widget.authProvider.user != null) {
                    Navigator.pushNamed(context, '/main');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pendaftaran gagal')),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 20),
            Text.rich(
              TextSpan(
                text: 'Sudah Punya Akun? ',
                style: TextStyle(color: Colors.black54),
                children: [
                  TextSpan(
                    text: 'Masuk disini',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/login');
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.black45),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Atau'),
                ),
                Expanded(
                  child: Divider(color: Colors.black45),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await widget.authProvider.signInWithGoogle();

                if (widget.authProvider.user != null) {
                  Navigator.pushNamed(context, '/main');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pendaftaran dengan Google gagal')),
                  );
                }
              },
              icon: SvgPicture.asset('assets/svgs/google_icon.svg', width: 30),
              label: Text('Daftar Dengan Google',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                side: BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupImagePicker extends StatelessWidget {
  final File? profileImage;
  final Function pickImage;

  SignupImagePicker({required this.profileImage, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          backgroundImage: profileImage != null
              ? FileImage(profileImage!)
              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromARGB(255, 6, 70, 116),
            child: IconButton(
              icon: Icon(
                Icons.camera_alt,
                size: 15,
                color: Colors.white,
              ),
              onPressed: () {
                pickImage();
              },
            ),
          ),
        ),
      ],
    );
  }
}
