import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../providers/auth_provider.dart';
import '../widgets/appBar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

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
          _profileImage = File(croppedFile.path); // Convert CroppedFile to File
        });

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.updateProfileImage(_profileImage!);
      }
    }
  }

  Future<void> _deleteProfileImage() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.deleteProfileImage();
    setState(() {
      _profileImage = null;
    });
  }

  void _showImageOptions() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = authProvider.userData;
    bool isDeleteDisabled = _profileImage == null && (userData?['profileImageUrl'] == null || userData!['profileImageUrl'].isEmpty);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile Picture'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: isDeleteDisabled ? Colors.grey : null),
              title: Text(
                'Delete Profile Picture',
                style: TextStyle(
                  color: isDeleteDisabled ? Colors.grey : null,
                ),
              ),
              onTap: isDeleteDisabled
                  ? null
                  : () async {
                      Navigator.pop(context);
                      await _deleteProfileImage();
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _profileImage != null
                ? Image.file(_profileImage!)
                : (authProvider.userData?['profileImageUrl'] != null &&
                        authProvider.userData!['profileImageUrl'].isNotEmpty
                    ? Image.network(authProvider.userData!['profileImageUrl'])
                    : Image.asset('assets/images/default_avatar.png')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userData = authProvider.userData;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profil',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showFullImage(authProvider),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (userData?['profileImageUrl'] != null &&
                                    userData!['profileImageUrl'].isNotEmpty
                                ? NetworkImage(userData['profileImageUrl'])
                                : AssetImage(
                                    'assets/images/default_avatar.png'))
                            as ImageProvider?,
                    child: (_profileImage == null &&
                            (userData?['profileImageUrl'] == null ||
                                userData!['profileImageUrl'].isEmpty))
                        ? null
                        : null,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color.fromARGB(255, 6, 70, 116),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      ),
                      onPressed: _showImageOptions,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              userData?['username'] ?? 'Nama Pengguna',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Text(
              user?.email ?? 'exampleemail@gmail.com',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('Tentang AutiVision'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Keluar'),
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      bool shouldLogout =
                          await _showLogoutConfirmationDialog(context);
                      if (shouldLogout) {
                        await authProvider.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Konfirmasi Logout'),
              content: Text('Apakah Anda yakin ingin keluar?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                  child: Text('Tidak'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                  child: Text('Ya'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
